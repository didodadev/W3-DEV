<cfinclude template="core.cfm">
<cfif not isDefined("attributes.class_id")><cfset attributes.class_id = url.class_id></cfif>
	
    <script language="javascript">
		function openCourse(courseID, e){window.open("<cfoutput>#PAGE_RTE#</cfoutput>id=" + courseID);}
	</script>
    <cfquery name="courses" datasource="#APPLICATION_DB#">
        SELECT 
            SCO.*
        FROM 
            #TABLE_SCO# AS SCO
		WHERE 
			CLASS_ID = #attributes.class_id#
        ORDER BY
            SCO.NAME, SCO.VERSION
    </cfquery>
	<cfsavecontent variable="header"><cfoutput>#getLang('','',62067)#</cfoutput></cfsavecontent>
	<cf_box
		title="#header#"
		closable="0">
		<cfform enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=training.emptypopup_add_course">
			<cf_box_elements vertical="1">
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><a href="javascript://" onclick="hide_show()"><cf_get_lang dictionary_id='62912.Scorm uyumlu içerik formatına uygun olarak XML dosyanızı yüklemek için tıklayın'></a>
						<cfinput type="hidden" name="class_id" value="#attributes.class_id#">
                    </div>
					<div id="scorm_contenct" class="col col-8" style="display:none;"><input id="uploadedContent" name="uploadedContent" type="file" onchange="return fileValidation()"/></div>
				</div>
				<div class="col col-12">
					<cf_box_footer>
						<cfif isdefined("xml_is_scorm_content_upload") and xml_is_scorm_content_upload eq 1 and courses.recordcount><!--- eğitim detayındaki xml den sadece 1 paket yüklensin seçili ise bu kontrole girer SG20120717--->
							<label><cf_get_lang dictionary_id="49385.Yüklü İçerik paketiniz..."></label>
						<cfelse>
							<cf_workcube_buttons>
						</cfif>
					</cf_box_footer>
				</div>
			</cf_box_elements>
		</cfform>
		
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang_main no='7.Eğitim'></th>
					<th><cf_get_lang no='11.Versiyon'></th>
					<th>&nbsp;</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="courses">
					<tr class="color-row">
						<td><cfoutput>#courses.NAME#</cfoutput></td>
						<td><cfoutput>#courses.VERSION#</cfoutput></td>
						<td>
							<cfset encId = encrypt(courses.sco_id, 'trainingSCO','CFMX_COMPAT','hex')>
							<a href="javascript://" onClick="openCourse('<cfoutput>#encId#</cfoutput>', event);" class="tableyazi"><cf_get_lang no='14.İzle'></a>
						</td>
						<td>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_upd_train_sco_detail&scoid=#courses.SCO_ID#</cfoutput>');"><img src="/images/update_list.gif"  border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a>
							<cfquery name="get_control" datasource="#application_db#" maxrows="1">
								SELECT DATA_ID FROM #TABLE_SCO_DATA# WHERE SCO_ID = #courses.SCO_ID#
							</cfquery>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.emptypopup_del_sco_data&scoid=#courses.SCO_ID#</cfoutput>','small');"><img src="/images/delete_list.gif"  border="0" title="<cf_get_lang_main no='51.Sil'>"></a>
						</td>
					</tr>
				</cfloop>
			</tbody>
		</cf_flat_list>
	</cf_box>
<script>
	$(document).ready(function(){
		$("#wrk_submit_button").val("<cf_get_lang dictionary_id='57464.Güncelle'>");
	});
	function hide_show(){
		if(document.getElementById("scorm_contenct").style.display='none'){
			document.getElementById("scorm_contenct").style.display='';
		}
	}
	function fileValidation()
	{
		/*
		var fileInput = document.getElementById('uploadedContent');
		var filePath = fileInput.value;
		console.log(filePath);
		var allowedExtensions = /(\.xml)$/i;
		console.log(allowedExtensions.exec(filePath));
		if(!allowedExtensions.exec(filePath)){
			alert('<cfoutput>#getLang("bank",379)#</cfoutput>!');
			fileInput.value = '';
			return false;
		}
		*/
	}          
</script>