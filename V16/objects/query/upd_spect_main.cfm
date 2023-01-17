<!--- spec kontroller
<cfquery name="get_order" datasource="#dsn3#">
	SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID = #attributes.spect_main_id# 
</cfquery>
<cfif get_order.recordcount>
	<cfquery name="UPD_VAR_SPECT" datasource="#dsn3#">
		UPDATE
			SPECT_MAIN
		SET
			SPECT_STATUS = <cfif isdefined('attributes.spect_status')>1<cfelse>0</cfif>,
            SPECT_MAIN_NAME = '#wrk_eval("attributes.SPECT_NAME")#' <!--- '#attributes.SPECT_NAME#' --->
		WHERE
			SPECT_MAIN_ID = #attributes.spect_main_id#
	</cfquery>
	<script type="text/javascript">
		alert('Spect kullanıldığı İçin Sadece Durumu Üzerinde Değişiklik Yapıldı.!');
		window.close();
	</script>
	<cfabort>
</cfif>--->
<!---// spec kontroller--->
<!---AYNI TARZ SPECT VARMI KONTROLU--->
<cfif isdefined("attributes.value_stock_id") and len(attributes.value_stock_id)>
	<cfscript>
	satir=0;
	form_stock_id_list="";
	form_amount_list="";
	form_sevk_list="";	
	form_amount_list_2="";
	property_id_list = '' ;
	variation_id_list = "" ;
	total_min_list = "" ;
	total_max_list = "" ;
	related_main_spec_id_list ="";
	operation_type_id_list="";
	if(len(attributes.tree_record_num) and attributes.tree_record_num gt 0)
		for(i=1;i lte attributes.tree_record_num;i=i+1)
			if(isdefined("attributes.tree_row_kontrol#i#") and evaluate("attributes.tree_row_kontrol#i#") eq 1)
			{
				satir=satir+1;
				if(listlen(evaluate('attributes.tree_product_id#i#'),',') gt 1 and isnumeric(listgetat(evaluate("attributes.tree_product_id#i#"),2,",")))
					form_stock_id_list = listappend(form_stock_id_list,listgetat(evaluate("attributes.tree_product_id#i#"),2,","),',');
				else
					form_stock_id_list = listappend(form_stock_id_list,evaluate("attributes.tree_stock_id#i#"),',');
				if(listlen(evaluate("attributes.tree_product_id#i#"),',') gte 9)
					operation_type_id_list = listappend(operation_type_id_list,listgetat(evaluate("attributes.tree_product_id#i#"),9,','),',');
				else
					operation_type_id_list = 0;
				form_amount_list = listappend(form_amount_list,evaluate("attributes.tree_amount#i#"),',');
				if(isdefined('attributes.tree_is_sevk#i#'))
					form_sevk_list = listappend(form_sevk_list,1,',');
				else
					form_sevk_list = listappend(form_sevk_list,0,',');
				if(isdefined('attributes.related_spect_main_id#i#') and len(Evaluate('attributes.related_spect_main_id#i#')))
					related_main_spec_id_list = ListAppend(related_main_spec_id_list,Evaluate('attributes.related_spect_main_id#i#'),',');
				else
					related_main_spec_id_list =  listappend(related_main_spec_id_list,0,',');
					
			}
	if (isdefined("attributes.pro_record_num") and len(attributes.pro_record_num))
		for(i=1;i lte attributes.pro_record_num;i=i+1)
			{
				satir=satir+1;
				if(len(evaluate("attributes.pro_amount#i#")))
					form_amount_list_2 = listappend(form_amount_list_2,evaluate("attributes.pro_amount#i#"),',');
				else
					form_amount_list_2 = listappend(form_amount_list_2,0,',');
				property_id_list =listappend(property_id_list,evaluate("attributes.pro_property_id#i#"),',');
				if(len(evaluate("attributes.pro_variation_id#i#")))
					variation_id_list = listappend(variation_id_list, ListGetAt(evaluate("attributes.pro_variation_id#i#"),1,','),',');
				else
					variation_id_list = listappend(variation_id_list,0,',');
				if(len(evaluate("attributes.pro_total_min#i#")))
					total_min_list =listappend(total_min_list,evaluate("attributes.pro_total_min#i#"),',');
				else
					total_min_list =listappend(total_min_list,'0',',');
				if(len(evaluate("attributes.pro_total_max#i#")))
					total_max_list =listappend(total_max_list,evaluate("attributes.pro_total_max#i#"),',');
				else
					total_max_list =listappend(total_max_list,'0',',');

			}
	</cfscript>
	<cfquery name="GET_SPECT_ROW_COUNT" datasource="#DSN3#">
		SELECT 
			COUNT(SPECT_MAIN.STOCK_ID),
			SPECT_MAIN.SPECT_MAIN_ID
		FROM 
			SPECT_MAIN,SPECT_MAIN_ROW
		WHERE
			SPECT_MAIN.SPECT_MAIN_ID=SPECT_MAIN_ROW.SPECT_MAIN_ID
			AND SPECT_MAIN.STOCK_ID=#attributes.value_stock_id#
			AND SPECT_MAIN.SPECT_MAIN_ID<>#attributes.spect_main_id#
		GROUP BY 
			SPECT_MAIN.SPECT_MAIN_ID
		HAVING 
			COUNT(SPECT_MAIN.STOCK_ID)=#satir#
	</cfquery>
	<cfset spect_list_id=valuelist(GET_SPECT_ROW_COUNT.SPECT_MAIN_ID,',')>
	<cfif listlen(spect_list_id,',')>
		<cfset st=0>
		<cfquery name="GET_SPECT" datasource="#dsn3#">
			SELECT 
				COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID),
				SPECT_MAIN.SPECT_MAIN_ID,
				SPECT_MAIN.SPECT_MAIN_NAME
			FROM 
				SPECT_MAIN_ROW ,
				SPECT_MAIN
			WHERE
				SPECT_MAIN.SPECT_MAIN_ID IN (#spect_list_id#) AND
				SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID
				<cfif listlen(form_stock_id_list,',')>
				 AND (
					<cfset st=0>
					<cfloop list="#form_stock_id_list#" index="stok">
						  <cfset st=st+1>
						(
							SPECT_MAIN_ROW.STOCK_ID=#stok# 
							AND SPECT_MAIN_ROW.AMOUNT=#listgetat(form_amount_list,st,',')#
							AND SPECT_MAIN_ROW.IS_PROPERTY=0
							AND IS_SEVK=#listgetat(form_sevk_list,st,',')#
						   <cfif len(ListGetAt(related_main_spec_id_list,st,',')) and ListGetAt(related_main_spec_id_list,st,',') gt 0>
								AND SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID = #ListGetAt(related_main_spec_id_list,st,',')#
							<cfelse>
								AND SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID IS NULL
							</cfif>
						) 
						<cfif listlen(form_stock_id_list) gt st>OR</cfif>
					</cfloop>
					)
				</cfif>
				<cfif listlen(property_id_list,',')>
				 AND (
					  <cfset st=0>
					  <cfloop list="#property_id_list#" index="property">
						<cfset st=st+1>
						(
							SPECT_MAIN_ROW.PROPERTY_ID=#property# 
							AND SPECT_MAIN_ROW.AMOUNT=#listgetat(form_amount_list_2,st,',')#
							AND SPECT_MAIN_ROW.IS_PROPERTY=1
							AND IS_SEVK=0
						) 
						<cfif listlen(property_id_list) gt st>OR</cfif>
					</cfloop>
					 )
				</cfif>
				<cfif listlen(variation_id_list,',')>
				 AND  (
					<cfset st = 0>
					<cfloop list="#variation_id_list#" index="variation">
						<cfset st=st+1>
						(
							SPECT_MAIN_ROW.VARIATION_ID=#variation# 
							AND SPECT_MAIN_ROW.AMOUNT=#listgetat(form_amount_list_2,st,',')#
							AND SPECT_MAIN_ROW.IS_PROPERTY=1
							AND IS_SEVK=0
						) 
						<cfif listlen(property_id_list) gt st>OR</cfif>
					</cfloop>
					  )
				</cfif>
				<cfif listlen(total_min_list,',')>
				 AND  (
					<cfset st = 0>
					<cfloop list="#total_min_list#" index="min">
						<cfset st=st+1>
						(
							SPECT_MAIN_ROW.TOTAL_MIN = #min# AND
							SPECT_MAIN_ROW.TOTAL_MAX = #ListGetAt(total_max_list,ListFind(total_min_list,min,','),',')#
						) 
						<cfif listlen(total_min_list) gt st>OR</cfif>
					</cfloop>
					  )
				</cfif>
			GROUP BY SPECT_MAIN.SPECT_MAIN_ID,SPECT_MAIN.SPECT_MAIN_NAME
			HAVING COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID)=#satir#
		</cfquery>
		<cfif GET_SPECT.RECORDCOUNT>
			<script type="text/javascript">
				alert('Bu özelliklerde bir spect var\n No:<cfoutput>#GET_SPECT.SPECT_MAIN_ID# #GET_SPECT.SPECT_MAIN_NAME#</cfoutput> ');
				window.close();
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>
<!---//AYNI TARZ SPECT VARMI KONTROLU--->
<cfif listfind(form_stock_id_list,attributes.value_stock_id,',')>
	<script type="text/javascript">
		alert('Ürünü Kendi Spectine Ekleyemezsiniz!');
		history.go(-1);
	</script>
</cfif>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="UPD_VAR_SPECT" datasource="#dsn3#">
		UPDATE
			SPECT_MAIN
		SET
			SPECT_MAIN_NAME = '#wrk_eval("attributes.SPECT_NAME")#' <!--- '#attributes.spect_name#' --->,
			SPECT_TYPE=1,
			PRODUCT_ID = <cfif isdefined("attributes.value_product_id")>#attributes.value_product_id#<cfelse>NULL</cfif>,
			STOCK_ID = <cfif isdefined("attributes.value_stock_id")>#attributes.value_stock_id#<cfelse>NULL</cfif>,
			<!--- IS_TREE=1, gerek yok hataya sebeb oluyor --->
			SPECT_STATUS = <cfif isdefined('attributes.spect_status')>1<cfelse>0</cfif>,
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#
		WHERE
			SPECT_MAIN_ID = #attributes.spect_main_id#
	</cfquery>

	<cfquery name="DEL_ROW" datasource="#dsn3#">
		DELETE FROM SPECT_MAIN_ROW WHERE SPECT_MAIN_ID = #attributes.spect_main_id#
	</cfquery>

	<cfif len(attributes.tree_record_num) and attributes.tree_record_num gt 0>
		<cfloop from="1" to="#attributes.tree_record_num#" index="i">
			<cfif isdefined("attributes.tree_row_kontrol#i#") and evaluate("attributes.tree_row_kontrol#i#") eq 1>
				<cfscript>
					if(listlen(evaluate('attributes.tree_product_id#i#'),',') gt 6)
					{
						form_product_id = listgetat(evaluate("attributes.tree_product_id#i#"),1,',');
						form_stock_id = listgetat(evaluate("attributes.tree_product_id#i#"),2,',');
						form_product_name = listgetat(evaluate("attributes.tree_product_id#i#"),7,',');
						if(listlen(evaluate("attributes.tree_product_id#i#"),',') gte 9)
							form_operation_id = listgetat(evaluate("attributes.tree_product_id#i#"),9,',');
						else
							form_operation_id = 0;
					}
					else if(isdefined("attributes.tree_product_name#i#"))
					{
						form_product_id = evaluate("attributes.tree_product_id#i#");
						form_stock_id = evaluate("attributes.tree_stock_id#i#");
						form_product_name = evaluate("attributes.tree_product_name#i#");
						form_operation_id = 0;
					}
					form_amount = evaluate("attributes.tree_amount#i#");
				</cfscript>
				<cfquery name="ADD_ROW" datasource="#dsn3#">
					INSERT INTO
						SPECT_MAIN_ROW
						(
							SPECT_MAIN_ID,
							PRODUCT_ID,
							STOCK_ID,
							OPERATION_TYPE_ID,
							AMOUNT,
							PRODUCT_NAME,
							IS_PROPERTY,
							IS_CONFIGURE,
							IS_SEVK,
                            RELATED_MAIN_SPECT_ID
						)
						VALUES
						(
							#attributes.spect_main_id#,
							<cfif len(form_product_id)>#form_product_id#<cfelse>NULL</cfif>,
							<cfif len(form_stock_id)>#form_stock_id#<cfelse>NULL</cfif>,
							<cfif len(form_operation_id)>#form_operation_id#<cfelse>NULL</cfif>,
							<cfif len(form_amount)>#form_amount#<cfelse>0</cfif>,
							<cfif len(form_product_name)>'#form_product_name#'<cfelse>NULL</cfif>,
							0,
							<cfif isdefined("attributes.tree_is_configure#i#") and len(evaluate("attributes.tree_is_configure#i#"))>1<cfelse>0</cfif>,
							<cfif isdefined("attributes.tree_is_sevk#i#")>1<cfelse>0</cfif>,
                            <cfif isdefined('attributes.related_spect_main_id#i#') and Evaluate('attributes.related_spect_main_id#i#') gt 0>#Evaluate('attributes.related_spect_main_id#i#')#<cfelse>NULL</cfif>
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<cfif  isdefined('attributes.pro_record_num') and len(attributes.pro_record_num) and attributes.pro_record_num neq "">
		<cfloop from="1" to="#attributes.pro_record_num#" index="i">
			<cfscript>
				form_amount = evaluate("attributes.pro_amount#i#");
				form_property_id = evaluate("attributes.pro_property_id#i#");
				form_variation_id = evaluate("attributes.pro_variation_id#i#");
				form_total_min = evaluate("attributes.pro_total_min#i#");
				form_total_max= evaluate("attributes.pro_total_max#i#");
				form_product_name = evaluate("attributes.pro_product_name#i#");
				form_tolerance =  evaluate("attributes.pro_tolerance#i#");
			</cfscript>
			<cfquery name="ADD_ROW" datasource="#dsn3#">
				INSERT INTO
					SPECT_MAIN_ROW
					(
						SPECT_MAIN_ID,
						AMOUNT,
						PROPERTY_ID,
						VARIATION_ID,
						TOTAL_MIN,
						TOTAL_MAX,
						PRODUCT_NAME,
						TOLERANCE,
						IS_PROPERTY,
						IS_CONFIGURE,
						IS_SEVK
					)
					VALUES
					(
						#attributes.spect_main_id#,
						<cfif len(form_amount)>#form_amount#,<cfelse>0,</cfif>
						<cfif len(form_property_id)>#form_property_id#,<cfelse>NULL,</cfif>
						<cfif len(form_variation_id)>#form_variation_id#,<cfelse>NULL,</cfif>
						<cfif len(form_total_min)>#form_total_min#,<cfelse>NULL,</cfif>
						<cfif len(form_total_max)>#form_total_max#,<cfelse>NULL,</cfif>
						<cfif len(form_product_name)>'#form_product_name#'<cfelse>NULL</cfif>,
						<cfif len(form_tolerance)>'#form_tolerance#'<cfelse>NULL</cfif>,
						1,
						0,
						<cfif isdefined("attributes.is_sevk#i#")>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfloop>
	</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.close();
</script>
