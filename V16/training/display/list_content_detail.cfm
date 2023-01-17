<style>
    .pageMainLayout{padding:0;}
</style>

<cfparam name="attributes.train" default="1">

<cfinclude template="../../rules/display/rule_menu.cfm">
<div class="wrapper" style="margin-top:-5px;padding:0 10px 0 10px;">
    <div class="col col-12">
	    <cfinclude template="general_training_menu.cfm">
    </div>
</div>

<div class="wrapper">
    <div id="wiki" class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfinclude  template="../../rules/display/dsp_rule.cfm">
    </div>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>