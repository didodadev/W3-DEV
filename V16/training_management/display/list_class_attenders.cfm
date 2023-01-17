<cf_xml_page_edit fuseact="training_management.popup_list_class_attenders">
<cfinclude template="../scorm_engine/core.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.emp_par_name" default="">
<cfparam name="attributes.is_completed" default="">
<cfquery name="GET_TRAINING_ATTENDERS" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_GROUP_ATTENDERS TGA
			INNER JOIN TRAINING_CLASS_GROUP_CLASSES TCGC ON TGA.TRAINING_GROUP_ID = TCGC.TRAIN_GROUP_ID
			INNER JOIN TRAINING_CLASS_GROUPS TCG ON TCG.TRAIN_GROUP_ID = TCGC.TRAIN_GROUP_ID
			INNER JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TCGC.CLASS_ID
			<cfif isDefined("attributes.emp_id")>
				LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = TGA.EMP_ID
			</cfif>
			<cfif isDefined("attributes.par_id")>
				LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = TGA.PAR_ID
			</cfif>
			<cfif isDefined("attributes.con_id")>
				LEFT JOIN CONSUMER C ON C.CONSUMER_ID = TGA.CON_ID
			</cfif>
			<cfif isDefined("attributes.grp_id")>
				LEFT JOIN USERS U ON U.GROUP_ID = TGA.GRP_ID
			</cfif>
	WHERE
		TCGC.CLASS_ID = #attributes.class_id#
</cfquery>
<cfquery name="get_train_groups" datasource="#dsn#">
  SELECT
    TCGC.TRAIN_GROUP_ID
  FROM
    TRAINING_CLASS_GROUP_CLASSES TCGC,
	TRAINING_CLASS_GROUPS TCG
  WHERE
    TCGC.TRAIN_GROUP_ID = TCG.TRAIN_GROUP_ID
</cfquery>
<cfset train_list = valuelist(get_train_groups.train_group_id)>
<cfif LEN(train_list)>
	<cfquery name="get_emp_id" datasource="#dsn#">
	SELECT 
		EMP_ID 
	FROM 
		TRAINING_GROUP_ATTENDERS 
	WHERE 
		TRAINING_GROUP_ID IN (#train_list#)
		AND EMP_ID IS NOT NULL
	</cfquery>
	<cfquery name="get_par_id" datasource="#dsn#">
	SELECT 
		PAR_ID 
	FROM 
		TRAINING_GROUP_ATTENDERS 
	WHERE 
		TRAINING_GROUP_ID IN (#train_list#)
		AND PAR_ID IS NOT NULL
	</cfquery>
	<cfquery name="get_cons_id" datasource="#dsn#">
	SELECT 
		CON_ID 
	FROM 
		TRAINING_GROUP_ATTENDERS 
	WHERE 
		TRAINING_GROUP_ID IN (#train_list#)
		AND CON_ID IS NOT NULL
	</cfquery>
	<cfquery name="get_grp_id" datasource="#dsn#">
	SELECT 
		GRP_ID 
	FROM 
		TRAINING_GROUP_ATTENDERS 
	WHERE 
		TRAINING_GROUP_ID IN (#train_list#)
		AND GRP_ID IS NOT NULL
	</cfquery>
</cfif>
<cfset url_str = "">
<cfset url_str = "#url_str#&class_id=#attributes.class_id#">
<cfif isdefined("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.emp_id")>
	<cfset url_str = "#url_str#&emp_id=#attributes.emp_id#">
</cfif>
<cfif isdefined("attributes.cons_id")>
	<cfset url_str = "#url_str#&cons_id=#attributes.cons_id#">
</cfif>
<cfif isdefined("attributes.par_id")>
	<cfset url_str = "#url_str#&par_id=#attributes.par_id#">
</cfif>
<cfif isdefined("attributes.emp_par_name")>
	<cfset url_str = "#url_str#&emp_par_name=#attributes.emp_par_name#">
</cfif>
<cfparam name="attributes.is_completed" default="">
<cfinclude template="../query/get_sco_data.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_data.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('','Yoklama',46381)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="class_attenders" id="class_attenders" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_training_group_attenders_detail&class_id=#attributes.class_id#">
		<cfinput type="hidden" name="row_count" value="#GET_TRAINING_ATTENDERS.recordcount#">
		<!--- Katılımcılar --->
		<cfquery name="get_training_groups" datasource="#dsn#">
			SELECT
				*
			FROM
				TRAINING_CLASS_GROUPS TCG
					INNER JOIN TRAINING_CLASS_GROUP_CLASSES TCGC ON TCGC.TRAIN_GROUP_ID = TCG.TRAIN_GROUP_ID
					INNER JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TCGC.CLASS_ID
			WHERE
				TC.CLASS_ID = #attributes.class_id#
		</cfquery>
		<!--- Dersin ekli olduğu sınıfların listesi --->
		<div class="row form-inline">
			<div class="form-group">
				<div class="input-group">
					<cf_get_lang dictionary_id='32326.Sınıf'><cf_get_lang dictionary_id='57734.Seçiniz'>:
				</div>
			</div>
			<div class="form-group" id="item-training_group">
				<div class="input-group">
					<select name="attenders" id="attenders" onchange="get_attenders()">
						<option value="0"><cf_get_lang dictionary_id='32326.Sınıf'><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_training_groups" group="train_group_id">
							<option value="#get_training_groups.train_group_id#">#get_training_groups.group_head#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<cf_get_lang dictionary_id="46015.Ders">: <cfoutput>#get_training_groups.class_name#</cfoutput>
				</div>
			</div>
		</div>
		<!--- //Dersin ekli olduğu sınıfların listesi --->

		<div id="attenders_list">
			<!--- Seçilen sınıfa göre katılımcıları listeliyor. --->
		</div>
        <cf_box_footer>
            <cf_workcube_buttons type_format='1' is_upd='0' add_function="kontrol_attender()">
        </cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
    function kontrol_attender(){
        <cfif isdefined("attributes.draggable")>
			loadPopupBox('class_attenders' , '<cfoutput>#attributes.modal_id#</cfoutput>');
			return false;
		</cfif>
    }
	function control()
	{
		row_count = $('#row_count').val();
		if (row_count > 0)
		{
			for (i=1;i<=row_count;i++)
			{
				$('#participation_rate_'+i).val(filterNum($('#participation_rate_'+i).val()));
			}
		}
	}
	function MailGonder()
	{
		//katılımcılar
		var is_selected=0;
		if(document.getElementsByName('row_demand').length > 0 || document.getElementsByName('row_demand_inf').length > 0)
		{
			var id_list="";
			if(document.getElementsByName('row_demand').length ==1)
			{
				if(document.getElementById('row_demand').checked==true)
				{
					is_selected=1;
					id_list+=document.class_attenders.row_demand.value+',';
				}
			}	
			else
			{
				for (i=0;i<document.getElementsByName('row_demand').length;i++){
						if(document.class_attenders.row_demand[i].checked==true){ 
							id_list+=document.class_attenders.row_demand[i].value+',';
							is_selected=1;
						}
				}		
			}	
			if(document.getElementsByName('row_demand_inf').length ==1)
			{
				if(document.getElementById('row_demand_inf').checked==true)
				{
					is_selected=1;
					id_list+=document.class_attenders.row_demand_inf.value+',';
				}
			}	
			else
			{
				for (i=0;i<document.getElementsByName('row_demand_inf').length;i++){
						if(document.class_attenders.row_demand_inf[i].checked==true){ 
							id_list+=document.class_attenders.row_demand_inf[i].value+',';
							is_selected=1;
						}
				}		
			}	
		}
		if(is_selected==1)
		{
			if(list_len(id_list,',') > 1)
			{
				id_list = id_list.substr(0,id_list.length-1);
				document.getElementById('id_list').value=id_list;
				document.getElementById('send_mail').value=1;
				send_mail_ = document.getElementById('send_mail').value;
				if(confirm("<cf_get_lang no='539.Mail Gönderilecek Emin misiniz'> ?"))
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training_management.emptypopup_send_mail_class_attenders&class_id=#attributes.class_id#</cfoutput>&send_mail_='+send_mail_+'&id_list='+document.getElementById('id_list').value,'mail_gonder');
			}
		}
		else
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1983.Katılımcı'>");
			return false;
		}
	}
	function get_attenders(){
		var train_group_id = $("#attenders option:selected").val();
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training_management.get_training_group_attenders&train_group_id=</cfoutput>'+train_group_id+'<cfoutput>&class_id=#attributes.class_id#</cfoutput>',"attenders_list");
	}
</script>