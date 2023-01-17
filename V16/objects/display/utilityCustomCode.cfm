<style>
.textwrapper {
    border: 1px solid #999999;
    height: 445px;
    width: 100%;
    display: block;
}
#customCode{
    width: 100%;
    height: 100%;
}
</style>
<form name="utilityCustomCodeForm" action="">
	<div class="row">
		<div class="col col-12">
			<div class="textwrapper"><textarea cols="2" rows="10" id="customCode"/></textarea></div>
		</div>
	</div>
	<div class="row">
		<div class="col col-12">
			<input type="button" onclick="setValue()" name="save" value="<cf_get_lang dictionary_id='57461.Kaydet'>" class="btn green-haze">
		</div>
	</div>	
</form>
<script type="text/javascript">
	function setValue() {
		var customCode = $("#customCode").val();
		var customCodeShort = customCode;
		if (customCodeShort.length > 20) {
			customCodeShort = customCodeShort.substr(0, 20) + "...";
		}
		window.opener.setFieldValue({ type: "customCode", value: "Code>" + customCodeShort, formula: customCode.replace( /#/g, "##" ), name: "customcode" });
		window.close();
	}
</script>