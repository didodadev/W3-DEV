
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="box_notes" title="#getLang('','Not',57467)#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_notes" method="post" action="#request.self#?fuseaction=objects.add_notes_visited">
			<cf_box_elements>
				<div class="col col-12 col-xs-12 col-md-12 col-s-12">
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'> *</label>
						<div class="col col-8 col-xs-12">
							<textarea style="width:140px;height:45px;" onChange="counter(this.form.detail,500);return ismaxlength(this);" name="detail" id="detail"  maxlength="500" onBlur="return ismaxlength(this);"></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32838.Not Bırakılan'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isdefined('attributes.employee_id')>
									<input type="hidden" name="member_visited_type" id="member_visited_type" value="employee">
									<input type="hidden" name="member_visited_id" id="member_visited_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
									<input type="text" name="member_visited" id="member_visited" value="<cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput>">
								<cfelse>
									<input type="hidden" name="member_visited_type" id="member_visited_type" value="employee">
									<input type="hidden" name="member_visited_id" id="member_visited_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
									<input type="text" name="member_visited" id="member_visited" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>">
								</cfif>   
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_type=add_notes.member_visited_type&field_emp_id2=add_notes.member_visited_id&field_name=add_notes.member_visited&select_list=1,2,3','','ui-draggable-box-medium');"></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='32493.Not Bırakan'></label>
						<div class="col col-8 col-xs-12">
							<cfif isdefined("session.ep.userid") and len(session.ep.userid)>
								<cfinput type="text" value="#session.ep.name# #session.ep.surname#" name="member" maxlength="200" required="yes" message="#getLang('','Lütfen İsminizi Giriniz',34110)#">
							<cfelse>
								<cfinput type="text" value="" name="member" maxlength="200" required="yes" message="#getLang('','Lütfen İsminizi Giriniz',34110)#">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-Mail'></label>
						<div class="col col-8 col-xs-12">
							<cfif not isdefined("session.ep.userid")>
								<cfinput type="text" name="email" required="yes"  validate="email" message="#getLang('','Lütfen geçerli bir e-mail adresi giriniz',58484)#">
							<cfelse>
								<cfinput type="text" name="email" validate="email" message="#getLang('','Lütfen geçerli bir e-mail adresi giriniz',58484)#"> 
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="tel" id="tel" onkeyup="isNumber(this);" maxlength="15">
						</div>
					</div>
				</div>	
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' type_format="1" add_function='#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('add_notes' , #attributes.modal_id#)"),DE(""))#'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script language="JavaScript" type="text/javascript">
document.getElementById('detail').focus();
function kontrol()
{
	if(document.add_notes.detail.value=="")
	{
		alert("<cf_get_lang dictionary_id='33337.Açıklama Girmelisiniz'> !");
		return false;
	}
	return true;
}
//Kalan karakter sayısını gösteriyor
function counter(field, countfield, maxlimit)
{ 
	if (field.value.length > maxlimit) 
	  {
			
			field.value = field.value.substring(0, maxlimit);
			alert(""+maxlimit+"<cf_get_lang dictionary_id='58997.Karakterden Fazla Yazmayınız'> !"); 
	   }
	else 
		countfield.value = maxlimit - field.value.length; 
} 
function reset() 
{ 
	document.getElementById("detail").value=""; 
	document.getElementById("detailLen").value="500"; 
}
</script>
