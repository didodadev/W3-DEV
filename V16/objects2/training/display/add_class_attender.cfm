<cfsetting showdebugoutput="no">
<cfform enctype="multipart/form-data" method="post" name="traineesForm" id="traineesForm">
<cfif isDefined("attributes.class_id") and len(attributes.class_id)>
	<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>"> 
<cfelseif isDefined("attributes.train_id") and len(attributes.train_id)>
	<input type="hidden" name="train_id" id="train_id" value="<cfoutput>#attributes.train_id#</cfoutput>"> 
</cfif>
<div class="ui-scroll">
<div class="row mb-3">
	<div class="col-md-4">
		<cf_get_lang dictionary_id='58607.Firma'>
	</div>
	<div class="col-md-6">
		<input type="text" class="form-control" name="trainees_firm" id="trainees_firm" value="" maxlength="255">
	</div>
</div>
<div class="row mb-3">
	<div class="col-md-4">
		<cf_get_lang dictionary_id='57570.Ad Soyad'>*
	</div>
	<div class="col-md-6">
		<input type="text" class="form-control" name="trainees" id="trainees" value="" maxlength="255">
	</div>
</div>
<div class="row mb-3">
	<div class="col-md-4">
		<cf_get_lang dictionary_id='57428.E-posta'>*
	</div>
	<div class="col-md-6">
		<input type="text" class="form-control" name="trainees_mail" id="trainees_mail" value="">
	</div>
</div>
<div class="row mb-3">
	<div class="col-md-4">
		<cf_get_lang dictionary_id='57499.Telefon'>
	</div>
	<div class="col-md-6">
		<input type="text" class="form-control" name="trainees_phone" id="trainees_phone" value="">
	</div>
</div>
<div class="row mb-3">
	<div class="col-md-4">
		<cf_get_lang dictionary_id='36199.Açıklama'>*
	</div>
	<div class="col-md-6">
		<textarea class="form-control" name="trainees_note" id="trainees_note" style="height:80px;"><cfif isDefined("attributes.description")><cfoutput>#attributes.description#</cfoutput></cfif></textarea>
	</div>
</div>
</div> 

<div class="draggable-footer">
	<cf_workcube_buttons is_insert="1" data_action="V16/objects2/cfc/widget/training:TRAINING_REQUEST" add_function="control()">
</div>
</cfform>
<script language="javascript" type="text/javascript">
	function control()
	{   
		if(document.getElementById('trainees').value == "")
		{
			alert("<cf_get_lang dictionary_id='34365.Lütfen Başvuru Yapanı Giriniz!'> !");
			return false;
		}
		var aaa = document.getElementById('trainees_mail').value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
			{ 
				alert("<cf_get_lang dictionary_id='626.Lütfen mail alanına geçerli bir mail giriniz'> !");
				return false;
			}
		
		var bbb = document.getElementById('trainees_mail').value;
		if (((bbb == '') || (bbb.indexOf('@') == -1) || (bbb.indexOf('.') == -1) || (bbb.length < 6)))
			{
				alert("<cf_get_lang dictionary_id='626.Lütfen mail alanına geçerli bir mail giriniz'> !");
				return false;
			}
		if(document.getElementById('trainees_note').value == "")
		{
			alert("<cf_get_lang dictionary_id='59512.Açıklama Alanı Zorunlu'> !");
			return false;
		}
		if(document.getElementById('trainees_note').value.length > 1000)
		{
			alert("<cf_get_lang dictionary_id='50599.Açıklama Alanı Uzun!'>");
			return false;
		}	
		
	}
</script>
