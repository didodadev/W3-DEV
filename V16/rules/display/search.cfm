<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_rule" action="#request.self#?fuseaction=rule.welcome" method="post">
	<input type="hidden" name="is_from_rule" id="is_from_rule" value="1">
  <div class="row">
    <div class="col col-12 border-bottom border-default">
      <div class="form-group margin-bottom-10">
        <div class="input-group">
            <cfinput type="text" name="keyword" id="keyword" style="width:140px;" value="#attributes.keyword#" maxlength="255">
            <span class="input-group-addon no-bg">
              <cf_wrk_search_button is_excel='0'>
              <span class="btn blue-steel btn-small" onClick="$('.ltDetailSearch').toggleClass('hide');"><cf_get_lang_main no ='492.Detaylı Arama'></span>
            </span>
        </div>
      </div>
    </div>
  </div>
</cfform>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>