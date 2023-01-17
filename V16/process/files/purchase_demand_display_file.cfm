<!---
    Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
    Date: 04.04.2021
    Description:
	Satınalma talebinde talep eden ve süreç inputlarının disabled durumu. (main display file) threpoint e id="icon" verilmelidir.
--->
<script type="text/javascript">
    function process_cat_dsp_function()
    {    
		$("#process_stage").addClass('disabled').prop({disabled : true});
		if($('#from_position_name').val())
			$("#from_position_name").attr("disabled", true);
		else if($('#from_name').val())
			$("#from_name").attr("disabled", true);
		$("#icon").prop('onclick',null).off('click');
	return true;
    }
</script>