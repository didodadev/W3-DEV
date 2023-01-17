<!--- list_my_trainings.cfm --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default=10>
<cfset url_str="keyword=#attributes.keyword#">
<cfinclude template="../query/get_emp_training.cfm">
      <table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
        <tr>
          <td class="headbold"><cf_get_lang no='36.Katıldığı Eğitimler'></td>
        </tr>
      </table>
      <table width="98%" border="0"  cellspacing="0" cellpadding="0" align="center">
        <tr class="color-border">
          <td>
            <table width="100%" border="0" height="100%" cellspacing="1" cellpadding="2">
              <tr class="color-header" height="22">
                <td class="form-title"><cf_get_lang no='72.Eğitim Adı'></td>
                <td class="form-title" width="300"><cf_get_lang no='84.Eğitim Yeri'></td>
                <td class="form-title" width="60"><cf_get_lang_main no='78.Gün'>/<cf_get_lang_main no='79.Saat'></td>
                <td class="form-title" width="125"><cf_get_lang_main no='89.Başlama'> - <cf_get_lang_main no='90.Bitiş'></td>
                <td class="form-title" width="100"><cf_get_lang no='40.Yoklama'></td>
                <td class="form-title" width="65"><cf_get_lang no='98.Ön Test'></td>
                <td class="form-title" width="65"><cf_get_lang no='99.Son Test'></td>
              </tr>
              <cfif get_tra_dep.recordcount>
                <cfoutput query="get_tra_dep" >
                  <cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_DT">
					  SELECT 
						  TCADT.ATTENDANCE_MAIN, 
						  TCADT.IS_EXCUSE_MAIN, 
						  TCADT.EXCUSE_MAIN, 
						  TCA.START_DATE
					  FROM 
						  TRAINING_CLASS_ATTENDANCE TCA, 
						  TRAINING_CLASS_ATTENDANCE_DT TCADT 
					  WHERE 
						  TCA.CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"> AND
						  TCADT.EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#"> AND 
                          TCADT.IS_TRAINER = 0 AND
						  TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID
                  </cfquery>
                  <cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_RESULTS">
					  SELECT 
						  PRETEST_POINT, 
						  FINALTEST_POINT 
					  FROM 
						  TRAINING_CLASS_RESULTS
					  WHERE 
					  	  CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"> AND
					  	  EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
                  </cfquery>
                 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td><a href="#request.self#?fuseaction=training.view_class&class_id=#CLASS_ID#" class="tableyazi">#CLASS_NAME#</a></td>
                    <td>#CLASS_PLACE#</td>
                    <td><cfif DATE_NO AND HOUR_NO>
                        #DATE_NO# / #HOUR_NO#
                      </cfif>
                    </td>
                    <td>#dateformat(START_DATE,dateformat_style)#-#dateformat(FINISH_DATE,dateformat_style)#</td>
                    <td>
                      <table width="98%" border="0"  cellspacing="0" cellpadding="0" align="center">
                        <cfloop query="GET_TRAIN_CLASS_DT">
                          <tr>
                            <td>#DateFormat(START_DATE,dateformat_style)#-
                              <cfif IsNumeric(ATTENDANCE_MAIN) AND ATTENDANCE_MAIN>
                                %#ATTENDANCE_MAIN#
                                <cfelseif IS_EXCUSE_MAIN IS 1>
                                #EXCUSE_MAIN#
                              </cfif>
                            </td>
                          </tr>
                        </cfloop>
                      </table>
                    </td>
                    <td>#GET_TRAIN_CLASS_RESULTS.PRETEST_POINT#</td>
                    <td>#GET_TRAIN_CLASS_RESULTS.FINALTEST_POINT#</td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="8"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
      
      <!--- katilacagi kesinlesen egitimler --->
      <table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
        <tr>
          <td class="headbold"><cf_get_lang no='100.Katılacağı Kesinleşen Eğitimler'></td>
        </tr>
      </table>
      <table width="98%" border="0"  cellspacing="0" cellpadding="0" align="center">
        <tr class="color-border">
          <td>
            <table width="100%" border="0" height="100%" cellspacing="1" cellpadding="2">
              <tr class="color-header" height="22">
                <td class="form-title"><cf_get_lang no='72.Eğitim Adı'></td>
                <td class="form-title" width="300"><cf_get_lang no='84.Eğitim Yeri'></td>
                <td class="form-title" width="60"><cf_get_lang_main no='78.Gün'>/<cf_get_lang_main no='79.Saat'></td>
                <td class="form-title" width="65"><cf_get_lang_main no='89.Başlama'></td>
                <td class="form-title" width="65"><cf_get_lang_main no='90.Bitiş'></td>
              </tr>
              <cfif get_trains.recordcount>
                <cfoutput query="get_trains" >
                 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td><a href="#request.self#?fuseaction=training.view_class&class_id=#CLASS_ID#" class="tableyazi">#CLASS_NAME#</a></td>
                    <td>#CLASS_PLACE#</td>
                    <td><cfif DATE_NO AND HOUR_NO>
                        #DATE_NO# / #HOUR_NO#
                      </cfif>
                    </td>
                    <td>#dateformat(START_DATE,dateformat_style)#</td>
                    <td>#dateformat(FINISH_DATE,dateformat_style)#</td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="6"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
     
      <!--- posizyonundan dolayi  --->
      <table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
        <tr>
          <td class="headbold"><cf_get_lang no='101.Alması Gereken Eğitimler (Pozisyon Tipi)'></td>
        </tr>
      </table>
      <table width="98%" border="0"  cellspacing="0" cellpadding="0" align="center">
        <tr class="color-border">
          <td>
            <table width="100%" border="0" height="100%" cellspacing="1" cellpadding="2">
             <tr class="color-header" height="22">
                <td class="form-title"><cf_get_lang no='72.Eğitim Adı'></td>
                <td class="form-title" width="300"><cf_get_lang no='84.Eğitim Yeri'></td>
                <td class="form-title" width="60"><cf_get_lang_main no='78.Gün'>/<cf_get_lang_main no='79.Saat'></td>
                <td class="form-title" width="65"><cf_get_lang_main no='89.Başlama'></td>
                <td class="form-title" width="65"><cf_get_lang_main no='90.Bitiş'></td>
              </tr>
              <cfif get_next_trains.recordcount>
                <cfoutput query="get_next_trains" >
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td><a href="#request.self#?fuseaction=training.view_class&class_id=#CLASS_ID#" class="tableyazi">#CLASS_NAME#</a></td>
                    <td>#CLASS_PLACE#</td>
                    <td><cfif DATE_NO AND HOUR_NO>
                        #DATE_NO# / #HOUR_NO#
                      </cfif>
                    </td>
                    <td><cfif D_TYPE eq 2>
                        #dateformat(START_DATE,dateformat_style)#
                      </cfif>
                    </td>
                    <td><cfif D_TYPE eq 2>
                        #dateformat(FINISH_DATE,dateformat_style)#
                      </cfif>
                    </td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
     
      <!--- departmanindan  dolayi  --->
      <table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
        <tr>
          <td class="headbold"><cf_get_lang no='102.Alması Gereken  Eğitimler (Departman)'></td>
        </tr>
      </table>
      <table width="98%" border="0"  cellspacing="0" cellpadding="0" align="center">
        <tr class="color-border">
          <td>
            <table width="100%" border="0" height="100%" cellspacing="1" cellpadding="2">
              <tr class="color-header" height="22">
                <td class="form-title"><cf_get_lang no='72.Eğitim Adı'></td>
                <td class="form-title" width="300"><cf_get_lang no='84.Eğitim Yeri'></td>
                <td class="form-title" width="60"><cf_get_lang_main no='78.Gün'>/<cf_get_lang_main no='79.Saat'></td>
                <td class="form-title" width="65"><cf_get_lang_main no='89.Başlama'></td>
                <td class="form-title" width="65"><cf_get_lang_main no='90.Bitiş'></td>
              </tr>
              <cfif get_tra_pos.recordcount>
                <cfoutput query="get_tra_pos" >
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td><a href="#request.self#?fuseaction=training.view_class&class_id=#CLASS_ID#" class="tableyazi">#CLASS_NAME#</a></td>
                    <td>#CLASS_PLACE#</td>
                    <td><cfif DATE_NO AND HOUR_NO>
                        #DATE_NO# / #HOUR_NO#
                      </cfif>
                    </td>
                    <td><cfif D_TYPE eq 2>
                        #dateformat(START_DATE,dateformat_style)#
                      </cfif>
                    </td>
                    <td><cfif D_TYPE eq 2>
                        #dateformat(FINISH_DATE,dateformat_style)#
                      </cfif>
                    </td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
	  <br/>


