<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
    <cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
</cfif>
<cf_popup_box title="Sipariş Mail Gönderimi">
<cfif attributes.is_all_mail eq 1>
	<cfset file_type_ = attributes.mail_type>
    <cfset file_id_ = coklu_siparis_mail_form>
            
	<cfif len(attributes.SET_IDS)>
    	<cfset attributes.SET_IDS = listsort(attributes.SET_IDS,'numeric')>
    </cfif>
    
    <cfloop list="#attributes.SET_IDS#" index="set_id">
    	<cfset attributes.s_mail = evaluate("attributes.f_mail_adress_#set_id#")>
    	<cfset mail_adres_ = listsort(trim(replace(attributes.s_mail," ","","all")),'text')>
    	<cfset mail_adres_ = ListChangeDelims(mail_adres_,';')>
        
        <cfset attributes.orders_list_ = evaluate("attributes.f_order_list_#set_id#")>
        <cfset attributes.orders_list_ = listsort(attributes.orders_list_,'numeric')>
        
        <cfquery name="upd_" datasource="#dsn3#">
            UPDATE
                ORDERS
            SET
                IS_MAIL = 1,
                MAIL_DATE = #NOW()#,
                MAIL_EMP = #session.ep.userid#
            WHERE
                ORDER_ID IN (#attributes.orders_list_#)
        </cfquery>
        
		<cfset url.orders = attributes.orders_list_>
        <cfquery name="GET_DET_FORM" datasource="#DSN#">
            SELECT 
                SPF.TEMPLATE_FILE,
                SPF.FORM_ID,
                SPF.IS_DEFAULT,
                SPF.NAME,
                SPF.PROCESS_TYPE,
                SPF.MODULE_ID,
                SPFC.PRINT_NAME
            FROM 
                #dsn3_alias#.SETUP_PRINT_FILES SPF,
                SETUP_PRINT_FILES_CATS SPFC,
                MODULES MOD
            WHERE
                SPF.FORM_ID = #file_id_# AND
                SPF.ACTIVE = 1 AND
                SPF.MODULE_ID = MOD.MODULE_ID AND
                SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
                SPFC.PRINT_TYPE = 91
            ORDER BY
                SPF.NAME
        </cfquery>
        <cfset attributes.is_mail_print = 1>
        <cfset filename = "siparis_toplu_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')#">
        <cfinclude template="/documents/settings/#GET_DET_FORM.TEMPLATE_FILE#">
        
        <cfset filename = "siparis_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')#">
		<cfif file_type_ is 'xls'>
            <cffile action="write" file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.#file_type_#" output="#mail_icerik_#" charset="utf-16"/>
        <cfelse>
            <cfdocument format="pdf" scale="100" pagetype="a4" filename="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.#file_type_#" marginleft="0" marginright="0" margintop="0">
            <style type="text/css">
                table{font-size:8px; font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:#333;}
                tr{font-size:8px;}
                th{font-size:8px;}
                td{font-size:8px;}
                
                tr.color-row td{background-color: #F4F9FD;}
                tr.color-row{background-color: #F4F9FD;}
                .color-row {background-color:#F4F9FD;}
                
                .color-border {background-color:#F4F9FD;}
                .color-border thead tr.color-list
                    {
                        background-color:#a7caed;
                        color:#6699CC;
                        font-weight:bold;
                        padding:2px;
                        height:22px;
                    }
                
                tr.color-header{background-color: #a7caed;}
                tr.color-header td{background-color: #a7caed;}
                .color-header {background-color: #a7caed;}
                
                .headbold {font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
                .form-title	{font-size:9px;font-family:Geneva, tahoma, arial,  sans-serif;color:white;font-weight : bold;}
                .big_list
                {
                 border:solid 1px #6699CC;	
                }
                .medium_list
                {
                 border:solid 1px #6699CC;	
                }
                thead tr
                    {
                        background-color:#DAEAF8;
                        color:#6699CC;
                        font-weight:bold;
                        padding:0px;
                        border:dotted 1px;
                        height:30px;
                    }
                thead tr th
                    {
                        padding:2px;
                        height:auto;
                        text-align:left;
                    }
                .medium_list
                    {
                        width:99%;
                        border-collapse: collapse;
                        background-color:#a7caed;
                        clear:both;
                        margin-bottom:10px;
                    }
                .big_list_header
                {
                    font-weight: bold; font-size:12px;
                }
                .medium_list thead tr th
                    {
                        
                        background-color:#DAEAF8;
                        color:#6699CC;
                        font-weight:bold;
                        padding:2px;
                        height:22px;
                    }
                .medium_list tbody tr td
                    {
                        color:#000000;
                        background-color:#FFF;
                        height:16px;
                        padding:2px;
                    }
                .medium_list tbody tr:hover td
                    {
                        background: #FF6;
                    }
                .medium_list tfoot tr
                    {
                        background-color:#DAEAF8;
                        height:30px;
                        padding:3px;
                        text-align:right;
                    }
                    
                .medium_list_header{font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 12px; font-weight: bold; padding-right:1px;}
            </style>
            <cfoutput>#mail_icerik_#</cfoutput>
           </cfdocument>
        </cfif>
    
       <!--- <cfmail 
            from="Gülgen Market<siparis@gulgen.com>" 
            subject="#attributes.siparis_baslik#" 
            to="#mail_adres_#" 
            server="192.168.0.15" 
            username="siparis@gulgen.com" 
            password="S4n4n300" 
            type="html"
            >
            <cfmailparam file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.#file_type_#">
            #attributes.siparis_icerik#
        </cfmail>--->
    </cfloop>
    Toplu Mail Başarıyla Gönderildi! <br />
<cfelseif attributes.is_one_one eq 1>
	<cfif len(attributes.SET_IDS)>
    	<cfset attributes.SET_IDS = listsort(attributes.SET_IDS,'numeric')>
    </cfif>
    
    <cfloop list="#attributes.SET_IDS#" index="set_id">
    	<cfset attributes.s_mail = evaluate("attributes.f_mail_adress_#set_id#")>
    	<cfset mail_adres_ = listsort(trim(replace(attributes.s_mail," ","","all")),'text')>
    	<cfset mail_adres_ = ListChangeDelims(mail_adres_,';')>
        
        <cfset attributes.orders_list_ = evaluate("attributes.f_order_list_#set_id#")>
        <cfset attributes.orders_list_ = listsort(attributes.orders_list_,'numeric')>
        
        <cfloop list="#attributes.orders_list_#" index="order_id_">
        	<cfset file_type_ = attributes.mail_type>
            <cfset file_id_ = tekli_siparis_mail_form>
            
            <cfquery name="GET_FORM" datasource="#dsn3#">
                SELECT TEMPLATE_FILE,FORM_ID,PROCESS_TYPE,IS_STANDART FROM SETUP_PRINT_FILES WHERE FORM_ID = #file_id_# ORDER BY IS_XML,NAME
            </cfquery>
            
            <cfquery name="upd_" datasource="#dsn3#">
                UPDATE
                    ORDERS
                SET
                    IS_MAIL = 1,
                    MAIL_DATE = #NOW()#,
                    MAIL_EMP = #session.ep.userid#
                WHERE
                    ORDER_ID = #order_id_#
            </cfquery>
            
            
            <cfsavecontent variable="mail_icerik_">
                <cfset attributes.action_id = order_id_>
                <cfinclude template="#file_web_path#settings/#get_form.template_file#">
            </cfsavecontent>
        
            <cfset filename = "siparis_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')#">
            <cfif file_type_ is 'xls'>
                <cffile action="write" file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.#file_type_#" output="#mail_icerik_#" charset="utf-16"/>
            <cfelse>
                <cfdocument format="pdf" scale="100" pagetype="a4" filename="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.#file_type_#" marginleft="0" marginright="0" margintop="0">
                <style type="text/css">
                    table{font-size:8px; font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:#333;}
                    tr{font-size:8px;}
                    th{font-size:8px;}
                    td{font-size:8px;}
                    
                    tr.color-row td{background-color: #F4F9FD;}
                    tr.color-row{background-color: #F4F9FD;}
                    .color-row {background-color:#F4F9FD;}
                    
                    .color-border {background-color:#F4F9FD;}
                    .color-border thead tr.color-list
                        {
                            background-color:#a7caed;
                            color:#6699CC;
                            font-weight:bold;
                            padding:2px;
                            height:22px;
                        }
                    
                    tr.color-header{background-color: #a7caed;}
                    tr.color-header td{background-color: #a7caed;}
                    .color-header {background-color: #a7caed;}
                    
                    .headbold {font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
                    .form-title	{font-size:9px;font-family:Geneva, tahoma, arial,  sans-serif;color:white;font-weight : bold;}
                    .big_list
                    {
                     border:solid 1px #6699CC;	
                    }
                    .medium_list
                    {
                     border:solid 1px #6699CC;	
                    }
                    thead tr
                        {
                            background-color:#DAEAF8;
                            color:#6699CC;
                            font-weight:bold;
                            padding:0px;
                            border:dotted 1px;
                            height:30px;
                        }
                    thead tr th
                        {
                            padding:2px;
                            height:auto;
                            text-align:left;
                        }
                    .medium_list
                        {
                            width:99%;
                            border-collapse: collapse;
                            background-color:#a7caed;
                            clear:both;
                            margin-bottom:10px;
                        }
                    .big_list_header
                    {
                        font-weight: bold; font-size:12px;
                    }
                    .medium_list thead tr th
                        {
                            
                            background-color:#DAEAF8;
                            color:#6699CC;
                            font-weight:bold;
                            padding:2px;
                            height:22px;
                        }
                    .medium_list tbody tr td
                        {
                            color:#000000;
                            background-color:#FFF;
                            height:16px;
                            padding:2px;
                        }
                    .medium_list tbody tr:hover td
                        {
                            background: #FF6;
                        }
                    .medium_list tfoot tr
                        {
                            background-color:#DAEAF8;
                            height:30px;
                            padding:3px;
                            text-align:right;
                        }
                        
                    .medium_list_header{font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 12px; font-weight: bold; padding-right:1px;}
                </style>
                <cfoutput>#mail_icerik_#</cfoutput>
               </cfdocument>
            </cfif>
        
            <cfmail 
                from="Gülgen Market<siparis@gulgen.com>" 
                subject="#attributes.siparis_baslik#" 
                to="#mail_adres_#" 
                server="192.168.0.15" 
                username="siparis@gulgen.com" 
                password="S4n4n300" 
                type="html"
                >
                <cfmailparam file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.#file_type_#">
                #attributes.siparis_icerik#
            </cfmail>
        </cfloop>
    </cfloop>
    Toplu Mail Başarıyla Gönderildi! <br />
<cfelseif attributes.is_alone eq 1>
	<cfset mail_adres_ = listsort(trim(replace(attributes.mail_adress," ","","all")),'text')>
    <cfset mail_adres_ = ListChangeDelims(mail_adres_,';')>
    <cfset file_type_ = attributes.mail_type>
    <cfset order_id_ = attributes.order_id>
    <cfset file_id_ = tekli_siparis_mail_form>
    
    <cfquery name="GET_FORM" datasource="#dsn3#">
		SELECT TEMPLATE_FILE,FORM_ID,PROCESS_TYPE,IS_STANDART FROM SETUP_PRINT_FILES WHERE FORM_ID = #file_id_# ORDER BY IS_XML,NAME
	</cfquery>
    
    <cfquery name="upd_" datasource="#dsn3#">
    	UPDATE
        	ORDERS
        SET
        	IS_MAIL = 1,
            MAIL_DATE = #NOW()#,
            MAIL_EMP = #session.ep.userid#
        WHERE
        	ORDER_ID = #order_id_#
    </cfquery>
    
    
    <cfsavecontent variable="mail_icerik_">
    	<cfset attributes.action_id = order_id_>
        <cfinclude template="#file_web_path#settings/#get_form.template_file#">
    </cfsavecontent>

	<cfset filename = "gulgen_siparis_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')#">
	<cfif file_type_ is 'xls'>
        <cffile action="write" file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.#file_type_#" output="#mail_icerik_#" charset="utf-16"/>
    <cfelse>
    	<cfdocument format="pdf" scale="100" pagetype="a4" filename="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.#file_type_#" marginleft="0" marginright="0" margintop="0">
		<style type="text/css">
			table{font-size:8px; font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:#333;}
			tr{font-size:8px;}
			th{font-size:8px;}
			td{font-size:8px;}
			
			tr.color-row td{background-color: #F4F9FD;}
			tr.color-row{background-color: #F4F9FD;}
			.color-row {background-color:#F4F9FD;}
			
			.color-border {background-color:#F4F9FD;}
			.color-border thead tr.color-list
				{
					background-color:#a7caed;
					color:#6699CC;
					font-weight:bold;
					padding:2px;
					height:22px;
				}
			
			tr.color-header{background-color: #a7caed;}
			tr.color-header td{background-color: #a7caed;}
			.color-header {background-color: #a7caed;}
			
			.headbold {font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
			.form-title	{font-size:9px;font-family:Geneva, tahoma, arial,  sans-serif;color:white;font-weight : bold;}
			.big_list
			{
			 border:solid 1px #6699CC;	
			}
			.medium_list
			{
			 border:solid 1px #6699CC;	
			}
			thead tr
				{
					background-color:#DAEAF8;
					color:#6699CC;
					font-weight:bold;
					padding:0px;
					border:dotted 1px;
					height:30px;
				}
			thead tr th
				{
					padding:2px;
					height:auto;
					text-align:left;
				}
			.medium_list
				{
					width:99%;
					border-collapse: collapse;
					background-color:#a7caed;
					clear:both;
					margin-bottom:10px;
				}
			.big_list_header
			{
				font-weight: bold; font-size:12px;
			}
			.medium_list thead tr th
				{
					
					background-color:#DAEAF8;
					color:#6699CC;
					font-weight:bold;
					padding:2px;
					height:22px;
				}
			.medium_list tbody tr td
				{
					color:#000000;
					background-color:#FFF;
					height:16px;
					padding:2px;
				}
			.medium_list tbody tr:hover td
				{
					background: #FF6;
				}
			.medium_list tfoot tr
				{
					background-color:#DAEAF8;
					height:30px;
					padding:3px;
					text-align:right;
				}
				
			.medium_list_header{font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 12px; font-weight: bold; padding-right:1px;}
		</style>
        <cfoutput>#mail_icerik_#</cfoutput>
       </cfdocument>
    </cfif>

    <cfmail 
    	from="Gülgen Market<siparis@gulgen.com>" 
        subject="#attributes.siparis_baslik#" 
        to="#mail_adres_#" 
        server="192.168.0.15" 
        username="siparis@gulgen.com" 
        password="S4n4n300" 
        type="html"
        >
        <cfmailparam file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.#file_type_#">
    	#attributes.siparis_icerik#
    </cfmail>
    Mail Başarıyla Gönderildi! <br />
    <hr />
    <br />
    Mail Adresleri : <cfoutput>#mail_adres_#</cfoutput>
</cfif>
</cf_popup_box>
<script>
	window.opener.location.reload();
</script>