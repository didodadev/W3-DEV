<cfquery name="get_all_quiz" datasource="#DSN#">
	SELECT
		EQU.QUIZ_HEAD,
		EQU.QUIZ_ID,
		IS_TRAINER,
		COMMETHOD_ID,
		IS_ACTIVE
	FROM
		EMPLOYEE_QUIZ EQU 
	WHERE
		IS_EDUCATION=1
		AND 
		IS_ACTIVE = 1
	ORDER BY
		EQU.QUIZ_HEAD
</cfquery>

<table width="98%" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td class="headbold" height="35"><cf_get_lang no='185.Eğitim Değerlendirme Formları'></td>
	</tr>
</table>
      <table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
        <tr class="color-border"> 
          <td> 
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header" height="22"> 
				<td class="form-title"><cf_get_lang no='203.Değerlendirme Formu Adı'></td>
				<td class="form-title"><cf_get_lang_main no='1967.Form'> </td>
              </tr>
			  <cfif get_all_quiz.RecordCount>
			  <cfoutput query="get_all_quiz"> 
				   <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td> 
					<a  class="tableyazi" href="javascript:add_record('#QUIZ_ID#','#attributes.CLASS_ID#');">#QUIZ_HEAD#</a>
					</td>
					<td>
						<cfif IS_TRAINER eq 1>
							<cf_get_lang no='321.Eğitmen için'>
						<cfelse>
							<cf_get_lang no='322.Eğitim Katılımcıları İçin'>
						</cfif>
					</td>
				  </tr>
              </cfoutput> 
              <cfelse>
				  <tr class="color-row" height="20"> 
					<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				  </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>

<script type="text/javascript">
	function add_record(quiz,clas)
	{
		window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.emptypopup_add_eval_quizes&class_id="+ clas+"&quiz_id="+quiz;
		wrk_opener_reload();
	}
</script>
