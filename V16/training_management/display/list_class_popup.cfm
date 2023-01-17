<cfsavecontent variable="ocak"><cf_get_lang_main no='180.Ocak'></cfsavecontent> 
<cfsavecontent variable="subat"><cf_get_lang_main no='181.şubat'></cfsavecontent> 
<cfsavecontent variable="mart"><cf_get_lang_main no='182.mart'></cfsavecontent> 
<cfsavecontent variable="nisan"><cf_get_lang_main no='183.nisan'></cfsavecontent> 
<cfsavecontent variable="mayis"><cf_get_lang_main no='184.mayıs'></cfsavecontent> 
<cfsavecontent variable="haziran"><cf_get_lang_main no='185.haziran'></cfsavecontent> 
<cfsavecontent variable="temmuz"><cf_get_lang_main no='186.temmuz'></cfsavecontent> 
<cfsavecontent variable="agustos"><cf_get_lang_main no='187.ağustos'></cfsavecontent> 
<cfsavecontent variable="eylul"><cf_get_lang_main no='188.eylül'></cfsavecontent> 
<cfsavecontent variable="ekim"><cf_get_lang_main no='189.ekim'></cfsavecontent> 
<cfsavecontent variable="kasim"><cf_get_lang_main no='190.kasım'></cfsavecontent> 
<cfsavecontent variable="aralik"><cf_get_lang_main no='191.aralık'></cfsavecontent> 

<cfset my_month_list="#ocak#,#subat#,#mart#,#nisan#,#mayis#,#haziran#,#temmuz#,#agustos#,#eylul#,#ekim#,#kasim#,#aralik#">

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.online" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.ic_dis" default="0">

<cfif isdefined("attributes.class_id")>
	<cfif isDefined('attributes.form_submitted') and len(attributes.form_submitted)>
		<cfquery name="ADD_CLASS_REL" datasource="#DSN#">
        	INSERT INTO
            	CLASS_RELATION
                (
                	ACTION_TYPE,
					ACTION_TYPE_ID,
                	CLASS_ID,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP                
                )
                VALUES
                (
                	'CLASS_ID',
					#attributes.action_type_id#,                    
                	#attributes.class_id#,
                	#session.ep.userid#,
                    #now()#,
                    '#cgi.remote_addr#'
                )	
        </cfquery>
	</cfif>
	<script type="text/javascript">
		//ek function gonderilmek istenirse diye eklendi fbs 20100628
		//hataya neden oldugu icin kapatildi 20120828
		<!--- <cfif isDefined("attributes.call_function") and Len(attributes.call_function)>
			window.opener.<cfoutput>#attributes.call_function#</cfoutput>; --->
		<cfif isdefined("attributes.class_id")>
			window.close();
			
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.location.reload();
		<cfelseif not isDefined("attributes.no_function")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.list_content_id_yukle();
		</cfif>
		window.close();
	</script>
	<cfabort>
</cfif>

<cfset url_str = "">
<cfif isDefined('attributes.form_submitted') and len(attributes.form_submitted)>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif isDefined('attributes.action_type_id') and len(attributes.action_type_id)>
	<cfset url_str = "#url_str#&action_type_id=#attributes.action_type_id#">
	<cfset url_str = "#url_str#&action_type=#attributes.action_type#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.online)>
	<cfset url_str = "#url_str#&online=#attributes.online#">
</cfif>
<cfif len(attributes.date1)>
	<cfset url_str = "#url_str#&date1=#attributes.date1#">					  
</cfif>
<cfif isDefined("attributes.ic_dis")>
   <cfset url_str = "#url_str#&ic_dis=#attributes.ic_dis#">
</cfif>
<cfif isDefined("attributes.rel_class") and len(attributes.rel_class)>
   <cfset url_str = "#url_str#&rel_class=#attributes.rel_class#">
</cfif>
    
<cfif isDefined('attributes.form_submitted') and len(attributes.form_submitted)>
    <cfinclude template="../query/get_class_ex_class.cfm">
<cfelse>
	<cfset get_class_ex_class.recordcount = 0>
</cfif>
<cfinclude template="../query/get_training_sec_names.cfm">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_class_ex_class.recordcount#>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('','Eğitimler',29912)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">

<cfform name="form1" method="post" action="#request.self#?fuseaction=training_management.popup_list_class#url_str#">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<input type="hidden" name="rel_class" id="rel_class" value="<cfif isDefined('attributes.rel_class') and len(attributes.rel_class)><cfoutput>#attributes.rel_class#</cfoutput></cfif>" />
<!--- <cf_big_list_search title="#getLang('main',2115)#"> --->
	<cf_box_search>
		<div class="row">
			<div class="form-inline col col-12 col-xs-12"> 
				<div class="form-group ">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main',48)#"  value="#attributes.keyword#" style="width:100px;">
				</div>
				<div class="form-group ">
					<div class="input-group">
						<cfset attributes.date1=dateformat(attributes.date1,dateformat_style)>
						<cfinput type="text" name="date1" id="date1" value="#attributes.date1#" required="yes" message="#getLang('','Tarih Girmelisiniz',56283)#">
						<span class="input-group-addon"> <cf_wrk_date_image date_field="date1"></span>
					</div>
				</div>
				<div class="form-group ">
					<select name="online" id="online">
						<option value=""<cfif attributes.online is ""> selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
						<option value="1"<cfif attributes.online is "1"> selected</cfif>><cf_get_lang_main no='2218.Online'></option>
						<option value="0"<cfif attributes.online is "0"> selected</cfif>><cf_get_lang no='159.Online Değil'></option>
					</select>
				</div>
				<div class="form-group ">
					<select name="ic_dis" id="ic_dis">
						<option value=""<cfif attributes.online is ""> selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
						<option value="0" <cfif attributes.IC_DIS is "0">selected</cfif>><cf_get_lang_main no='1149.İç'></option>
						<option value="1" <cfif attributes.IC_DIS is "1">selected</cfif>><cf_get_lang_main no='1150.Dış'></option>
					</select>
				</div>
				<div class="form-group ">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form1' , #attributes.modal_id#)"),DE(""))#">
                </div>
				<!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>  --->
			</div>
		</div>
	</cf_box_search>

</cfform>
<cf_grid_list>
	<thead>
		<tr> 
			<th><cf_get_lang_main no='7.Eğitim'></th>
			<th style="width:30px;"><cf_get_lang_main no='218.Tip'></th>
			<th style="width:100px;"><cf_get_lang no='187.Eğitim Yeri'></th>
			<th style="width:100px;"><cf_get_lang no='23.Eğitimci'></th>
			<th style="width:200px;"><cf_get_lang_main no='330.Tarih'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_class_ex_class.recordcount>
			<cfoutput query="get_class_ex_class" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<tr>
					<td>
                    	<cfif isDefined('attributes.rel_class') and attributes.rel_class eq 1>
                    		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#attributes.fuseaction#&class_id=#class_id##url_str#','content_list',1)">#class_name#</a>
						<cfelse>
                    		#class_name#
                    	</cfif>
                    </td>
					<td><cfif type eq 1><cf_get_lang_main no ='1150.Dış'><cfelse><cf_get_lang_main no='1149.İç'></cfif></td>
					<td>#class_place#</td>
					<td>
						<cfset attributes.class_id = class_id>
						<!---<cfif isDefined('type') and type eq 0>
							<cfinclude template="../query/get_class_trainer.cfm">
						<cfelseif isDefined('type') and type eq 1>
							<cfinclude template="../query/get_ex_class_trainer.cfm">
						</cfif>
						<cfif isdefined("get_class_trainer_emp") and get_class_trainer_emp.recordcount>
							#get_class_trainer_emp.employee_name# #get_class_trainer_emp.employee_surname#
						</cfif>
						<cfif isdefined("get_class_trainer_par") and get_class_trainer_par.recordcount>
							#get_class_trainer_par.company_partner_name# #get_class_trainer_par.company_partner_surname# - #get_class_trainer_par.nickname#
						</cfif>--->
						<!--- <cfif TYPE IS 'İÇ' and GET_CLASS_TRAINER_CONS.RECORDCOUNT>
						#GET_CLASS_TRAINER_CONS.CONSUMER_NAME# #GET_CLASS_TRAINER_CONS.CONSUMER_SURNAME#
						</cfif> --->
					</td>
					<td>
						<cfif len(start_date) and start_date gt '1/1/1900' and len(finish_date) and finish_date gt '1/1/1900'>
							<cfif dateformat(start_date,dateformat_style) eq dateformat(now(),dateformat_style) or dateformat(finish_date,dateformat_style) eq dateformat(now(),dateformat_style) ><font  color="##FF0000"> </cfif>
							<cfset startdate = date_add('h', session.ep.time_zone, start_date)>
							<cfset finishdate = date_add('h', session.ep.time_zone, finish_date)>
								#dateformat(startdate,dateformat_style)# (#timeformat(startdate,timeformat_style)#) - #dateformat(finishdate,dateformat_style)# (#timeformat(finishdate,timeformat_style)#) 
							<cfelseif isdefined("class_date") and len(class_date) and class_date gt '1/1/1900'>
								#dateformat(class_date,dateformat_style)#
							<cfelseif len(month_id) and month_id>
								#ListGetAt(my_month_list,month_id)# - #session.ep.period_year#
						</cfif>
					</td>
				</tr>
			</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="8"><cfif isDefined('attributes.form_submitted') and len(attributes.form_submitted)><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
		<cfset url_string = '#url_str#&draggable=#attributes.draggable#'>
	</cfif>
				<cf_paging 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="training_management.popup_list_class#url_string#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#"> 

</cfif>
</cf_box>
