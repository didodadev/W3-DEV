<!---Bu customtag in  amacı var olan bir bilginin güncellenmeden önce bilgileri istenilen database kaydetmektir. --->
<!--- <cf_wrk_get_history 
		datasource= kaydedilecek database kaynağı
		source_table= bilgilerin alındığı database
		target_table= bilgilerin kaydedildiği database
		insert_column_name=ek database tablo isimleri
		insert_column_value=ek database tablo değerleri
		record_id= bilgileri alınan id bu bir tane veya birden çok olabilir.,
		record_name=bilgilerin alındığı Id nin kolon ismi >--->
    <!---IKI TABLO ARASINDA KI ORTAK KOLANLAR ALINIR--->
	<cfparam name="attributes.insert_column_name" default="">
	<cfparam name="attributes.insert_column_value" default="">
	<cfquery name="get_targetcolumn_name" datasource="#attributes.datasource#">
        SELECT 
            COLUMN_NAME,
			DATA_TYPE,
			ISNULL(COLUMNPROPERTY(OBJECT_ID('#attributes.target_table#'), COLUMN_NAME, 'ISIDENTITY'),0) IDENTITY_
        FROM 
            INFORMATION_SCHEMA.COLUMNS 
        WHERE 
            TABLE_NAME = '#attributes.target_table#' AND 
			TABLE_SCHEMA = '#attributes.datasource#'
	</cfquery>
    <cfquery name="get_columns_name" datasource="#attributes.datasource#">
		SELECT 
			COLUMN_NAME  
		FROM 
			INFORMATION_SCHEMA.COLUMNS 
		WHERE 
			TABLE_NAME = '#attributes.target_table#' AND
			COLUMN_NAME IN (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='#attributes.source_table#') AND
			ISNULL(COLUMNPROPERTY(OBJECT_ID('#attributes.target_table#'), COLUMN_NAME, 'ISIDENTITY'),0) = 0 and
			TABLE_SCHEMA = '#attributes.datasource#'
    </cfquery>
	<!--- BU  ÇEKILEN KOLONLAR BIR LISTEYE ALINIR--->
	<cfset column_list=ValueList(get_columns_name.column_name,',')>	
	<!---KOPYALAMA İŞLEMİ GERÇEKLEŞTİRİLİYOR--->
	<cfset maxId=''>
	<cfloop list="#attributes.record_id#" index="index"> <!--- from="1" to="#listlen(attributes.record_id)#" index="index">--->
		<cfquery name="save_history_details" datasource="#attributes.datasource#">
			INSERT INTO  #attributes.target_table#
				(
					#column_list#
				)
				SELECT
					#column_list#
				FROM   
					#attributes.source_table# 
				WHERE 
					#attributes.record_name# = #index#
				SELECT SCOPE_IDENTITY() AS MAX_ID
		</cfquery>
		<cfset maxId=listappend(maxId,save_history_details.max_id,',')>
<!---        <cfdump var="#save_history_details#"><cfdump var="#index#"><br/>--->
	</cfloop>

	<cfif listlen(attributes.insert_column_name) and listlen(attributes.insert_column_value) and (listlen(attributes.insert_column_name) eq listlen(attributes.insert_column_value))>
		<cfquery name="get_identity" dbtype="query">
			SELECT COLUMN_NAME FROM get_targetcolumn_name WHERE IDENTITY_=1
		</cfquery>
		<cfquery name="upd_target" datasource="#attributes.datasource#">
			UPDATE  
				#attributes.target_table# 
			SET 
				<cfloop list="#attributes.insert_column_name#" index="i" delimiters=",">
					 <cfset number=listfind(valuelist(get_targetcolumn_name.column_name),i,',')>
					 <cfset x=listfind(attributes.insert_column_name,i,',')>
						 <cfif number neq 0>
							 <cfif listgetat(valuelist(get_targetcolumn_name.data_type),number,',') eq 'nvarchar'>
								#listgetat(attributes.insert_column_name,x,',')#=<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.insert_column_value,x,',')#">
							 <cfelseif listgetat(valuelist(get_targetcolumn_name.data_type),number,',') eq 'datetime'>
								#listgetat(attributes.insert_column_name,x,',')#=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#listgetat(attributes.insert_column_value,x,',')#">
							 <cfelse>
							 	#listgetat(attributes.insert_column_name,x,',')#=<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.insert_column_value,x,',')#">
							</cfif>
							 <cfif x neq listlen(attributes.insert_column_name)>,</cfif>
						</cfif>
				</cfloop>
			WHERE
				#valuelist(get_identity.column_name,',')# IN (#maxId#)
		</cfquery>
	</cfif>	
