<cfset getComponent_1 = createObject('component','V16.project.cfc.get_work')>
<cfform name="add_notes" method="post">
    <cfinput type="hidden" name="iid" id="iid" value="#attributes.iid#">
	<cfif isdefined('attributes.workgroup_id')>
		<input type="hidden" name="workgroup_id" id="workgroup_id" value="<cfoutput>#attributes.workgroup_id#</cfoutput>">
	</cfif>
	<div class="row">
		<div class="col-lg-12 col-xl-12">
			<div class="form-row mb-3">
				<div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57629.Açıklama'></div>
				<div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
					<textarea class="form-control" onChange="counter(this.form.detail,500);return ismaxlength(this);" name="detail" id="detail"  maxlength="500" onBlur="return ismaxlength(this);"></textarea>
				</div>
			</div>
			<div class="form-row mb-3">
				<div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id ='32493.Not Bırakan'></div>
				<div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
					<cfsavecontent variable="alert"><cf_get_lang no ='1290.Lütfen İsminizi Giriniz'></cfsavecontent>
					<cfif isdefined("session.ep.userid") and len(session.ep.userid)>                        
						<cfinput type="text" name="member" id="member" value="#session.ep.name# #session.ep.surname#"  maxlength="200" required="yes" message="#alert#" class="form-control">
					<cfelse>
						<cfinput type="text"name="member" id="member" value="#session.pp.name# #session.pp.surname#"  maxlength="200" required="yes" message="#alert#" class="form-control">
					</cfif>
				</div>
			</div>
			<div class="form-row mb-3">
				<div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='32838.Not Bırakılan'></div>
				<div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
					<cfif isdefined("session.ep")>	
						<input type="hidden" name="member_visited_type" id="member_visited_type" value="1">
						<cfset get_emp = getComponent_1.GET_POSITIONS(our_cid : session.ep.our_company_id)>
						<select class="form-control" id="member_visited_id" name="member_visited_id">
							<option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_emp">
								<option value="#employee_id#" <cfif session.ep.userid eq employee_id>selected</cfif>>#employee_name# #employee_surname#</option>
							</cfoutput>
						</select>				
					<cfelseif isdefined("session.pp")>								
						<input type="hidden" name="member_visited_type" id="member_visited_type" value="2">
						<cfset get_part = getComponent_1.GET_POSITIONS(our_cid : session.pp.our_company_id)>
						<select class="form-control" id="member_visited_id" name="member_visited_id">
							<option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_part">
								<option value="#employee_id#" <cfif session.pp.userid eq employee_id>selected</cfif>>#employee_name# #employee_surname#</option>
							</cfoutput>
						</select>
					</cfif>				
				</div>
			</div>
			<div class="form-row mb-3">
				<div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57499.Telefon'></div>
				<div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
					<input type="text" name="tel" id="tel" onkeyup="isNumber(this);" maxlength="15" class="form-control">
				</div>
			</div>
			<div class="form-row mb-3">
				<div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57428.E-Mail'></div>
				<div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
					<cfinput type="text" name="email" id="email" validate="email" class="form-control" message="#getLang('','Lütfen geçerli bir e-mail adresi giriniz',58484)#">
				</div>
			</div>
		</div>
	</div>
	<div class="form-group">
		<cf_workcube_buttons is_insert="1" data_action="/V16/objects2/protein/data/add_notes:add_notes" next_page="#site_language_path#/#attributes.next#?#attributes.id#="  after_function="kontrol">
	</div>
</cfform>
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
