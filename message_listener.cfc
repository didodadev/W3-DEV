<cfscript>
component extends = "CFIDE.websocket.ChannelListener" output="true"{

	public any function beforePublish(any message, Struct SubscriberInfo)
	{
		try {
			
			file_system = createObject("component","V16.asset.cfc.file_system");

			upload_folder = application.systemParam.systemParam().upload_folder;
			receiver_id = SubscriberInfo.receiver_id;
			receiver_type = '0'; //TEST
			message = ReReplaceNoCase(message,"<[^>]*>","","ALL"); //tag temizle
			is_chat = 0;
			send_date = now();
			token = SubscriberInfo.token;
			encryptionKey ="dvayMin0XFT2PQp8PMinoA==";
			decoded = decrypt(token,encryptionKey,"AES","hex");
			sender_id = ListFirst(decoded,"/*/*/");
			dsn = ListLast(decoded,"/*/*/");

			decoded_1 = ListDeleteAt(decoded,1,"/*/*/");// 1. sil
			sender_type = ListFirst(decoded_1,"/*/*/"); // 2. 1. oldu
			decoded_2 = ListDeleteAt(decoded_1,1,"/*/*/");
			receiver_type = ListFirst(decoded_2,"/*/*/");

			messageFile = ( SubscriberInfo.msgContent.isFile ) ? 1 : 0;
			is_deleted = ( SubscriberInfo.msgContent.messageStatus.isDeleted ) ? 1 : 0;
			is_delivered = ( SubscriberInfo.msgContent.messageStatus.isForward ) ? 1 : 0;
			group_id = SubscriberInfo.msgContent.group.group_id;
			enc_key = structKeyExists( SubscriberInfo.msgContent, 'enc_key' ) ? SubscriberInfo.msgContent.enc_key : '';

			//Grup mesajları 1 tane oluşturulur n tane kişiye gönderilir!

			if( SubscriberInfo.msgContent.addMessage ){
				
				QueryExecute(
					"INSERT INTO
					WRK_MESSAGE
					(
						RECEIVER_ID,
						RECEIVER_TYPE,
						SENDER_ID,
						SENDER_TYPE,
						MESSAGE,
						IS_CHAT,
						SEND_DATE,
						MESSAGE_FILE,
						IS_DELIVERED,
						WG_ID,
						ENC_KEY
					)
					VALUES
					(:receiver_id,:receiver_type,:sender_id,:sender_type,:message,:is_chat,:send_date,:msgFile,:is_delivered,:wg_id,:enc_key)",
					{
						receiver_id = {value=receiver_id,cfsqltype='CF_SQL_INTEGER',null=(len(group_id) or receiver_id contains '-')  ? true : false},
						receiver_type = (receiver_id contains '-') ? 4 : receiver_type,
						sender_id = sender_id,
						sender_type = sender_type,
						message = message,
						is_chat = is_chat,
						send_date = {value='#now()#',cfsqltype='CF_SQL_TIMESTAMP'},
						msgFile = messageFile,
						is_delivered = is_delivered,
						wg_id = {value=group_id,cfsqltype='CF_SQL_INTEGER',null=len(group_id) ? false : true},
						enc_key = {value=enc_key,cfsqltype='CF_SQL_NVARCHAR',null=len(enc_key) ? false : true}
					},
					{datasource="#dsn#", result: "result"}
				);

				groupUsers = SubscriberInfo.msgContent.group.groupUsers;

				if( len( group_id ) and isArray( groupUsers ) ){///Grup mesajları gruptaki kişilere tanımlanır

					for( i = 1; i <= arrayLen(groupUsers); i++ ){

						QueryExecute(
							"INSERT INTO
							WRK_MESSAGE_GROUP_EMP_MSG
							(
								WG_ID,
								WRK_MESSAGE_ID,
								EMPLOYEE_ID,
								IS_ALERTED,
								IS_DELETED
							)
							VALUES
							(:wg_id,:wrk_message_id,:employee_id,:is_alerted,:is_deleted)",
							{wg_id=group_id,wrk_message_id=result.IDENTITYCOL,employee_id=groupUsers[i],is_alerted=0,is_deleted=0},
							{datasource="#dsn#"}
						);

					}

				}

				///Eğer dosya eklenmişse WRK_MESSAGE_FILES tablosuna dosya bilgilerini yazar
				if( SubscriberInfo.msgContent.isFile ){
					
					createId = createUUID();

					SubscriberInfo.msgContent.file.encryptedName = len( SubscriberInfo.msgContent.file.encryptedName ) ? SubscriberInfo.msgContent.file.encryptedName : createId;
					SubscriberInfo.msgContent.file.fullEncryptedName = len( SubscriberInfo.msgContent.file.fullEncryptedName ) ? SubscriberInfo.msgContent.file.fullEncryptedName : (createId & "." & SubscriberInfo.msgContent.file.ext);

					if( structKeyExists( SubscriberInfo.msgContent.file, 'folderInfo' ) ){

						file_system.rename(
							filePath: '#SubscriberInfo.msgContent.file.folderInfo.parentFolder#/#SubscriberInfo.msgContent.file.folderInfo.childFolder#/#SubscriberInfo.msgContent.file.fullEncryptedName#',
							newfilePath: '#upload_folder##SubscriberInfo.msgContent.file.folderInfo.parentFolder#/#SubscriberInfo.msgContent.file.fullEncryptedName#'
						);

					}

					QueryExecute(
						"INSERT INTO
							WRK_MESSAGE_FILES
							(
								MESSAGE_ID,
								MESSAGE_FILE_NAME,
								MESSAGE_FILE_ENCRYPTED_NAME,
								MESSAGE_FILE_FULL_NAME,
								MESSAGE_FILE_ENCRYPTED_FULL_NAME,
								MESSAGE_FILE_EXTENTION,
								MESSAGE_FILE_SIZE,
								MESSAGE_FILE_MIME_TYPE
							)
							VALUES
							(
								:message_id,
								:message_file_name,
								:message_file_encrypted_name,
								:message_file_full_name,
								:message_file_encrypted_full_name,
								:message_file_extention,
								:message_file_size,
								:message_file_mime_type
							)
						",
							{
								message_id = result.IDENTITYCOL,
								message_file_name = SubscriberInfo.msgContent.file.fileName,
								message_file_encrypted_name = SubscriberInfo.msgContent.file.encryptedName,
								message_file_full_name = SubscriberInfo.msgContent.file.fullfileName,
								message_file_encrypted_full_name = SubscriberInfo.msgContent.file.fullEncryptedName,
								message_file_extention = SubscriberInfo.msgContent.file.ext,
								message_file_size = SubscriberInfo.msgContent.file.fileSize,
								message_file_mime_type = SubscriberInfo.msgContent.file.mimeType
							},
							{datasource="#dsn#"}
					);

				}
			}

			///Grup mesajlaşmalarında sadece 1 mesaj kaydı yapılır! 
			///Her bir kullanıcı için message_listener tetiklenir. Bu nedenle; ilk gönderilen mesajdan sonraki tüm mesajlar, ilk  mesaj bilgisiyle dönülür.
			if( len( group_id ) and !SubscriberInfo.msgContent.addMessage ){
				
				get_last_messages = QueryExecute(
					"SELECT TOP 1 * FROM WRK_MESSAGE WHERE SENDER_ID = :sender_id ORDER BY WRK_MESSAGE_ID DESC",
					{sender_id = { value = sender_id, cfsqltype = 'CF_SQL_INTEGER' }},
					{datasource="#dsn#"}
				);
				message_id = get_last_messages.WRK_MESSAGE_ID;
				
			}else message_id = result.IDENTITYCOL;

			response = {
				message_id: message_id,
				message: message,
				messageStatus: { is_deleted: is_deleted, is_delivered: is_delivered },
				sender_id: sender_id,
				file: {
					isFile: SubscriberInfo.msgContent.isFile ? true : false,
					data: [(SubscriberInfo.msgContent.isFile) ? SubscriberInfo.msgContent.file : {}]
				},
				group: { group_id: group_id },
				enc_key: enc_key
			};


			//response içeriğini görmek için açılabilir
			//documents/messageFiles dizinine çıktı verir
			/* saveContent variable = 'fixes' {
				writeDump( response );
				writeDump( SubscriberInfo.msgContent );
				WriteOutput( lCase(Replace(serializeJson(SubscriberInfo.msgContent),"//","")));
				WriteOutput( Replace(serializeJson(response),"//",""));
			}
			fileWrite( upload_folder & "/messageFiles/fixes_1111.html",fixes ); */

			return Replace(serializeJson(response),"//","");

		} catch (any exName) {
			saveContent variable = 'fixes' {
				writeDump( response );
				writeDump( SubscriberInfo );
				writeDump( exName );
			}
			fileWrite( upload_folder & "/messageFiles/fixes.html",fixes );
			
			return "{}";

		}

	}

}
</cfscript>