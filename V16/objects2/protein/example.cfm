Protein Example Test Widgetı
<form class="col-12" name="contactForm2" id="contactForm2">
    
    <div class="form-group">
      <label for="input-text">TEXT</label>
      <input type="text" class="form-control" id="input-text" name="input-text">
    </div>
    <div class="form-group">
        <label class="label_form"><cf_get_lang dictionary_id='57467.Not'></label>
        <textarea class="form-control" rows="3" maxlength="5000" name="contact_note" id="contact_note"></textarea>
    </div>
    <div class="form-group row">
      <label class="col-sm-3 col-form-label"><cf_get_lang dictionary_id='64176.CV Yükle'> *</label>
      <div class="col-sm-9">
        <input class="form-control" type="file" name="file_example_input" id="file_example_input" accept=".pdf" style="padding:3px 0px 0px 8px;">
        <span><cf_get_lang dictionary_id='64183.Yalnızca pdf formatında dosya yükleyebilirsiniz'>!</span>
      </div>
    </div>
    <cf_workcube_buttons is_insert="1" data_action="V16/objects2/protein/data/protein_example:CONTROL_FORM"  add_function="control()">
</form>

<script language="javascript" type="text/javascript">
function control()
	{   

  }
</script>