<!--- 20060405 bu ekran ve icindeki include larin query leri view dan dolayi kaldirildi, ancak daha onceki bir baskup tan bakilabilir --->
<cfquery name="GET_COMPANY_RISK" datasource="#dsn2#">
	SELECT 
		BAKIYE,
		CEK_ODENMEDI,
		CEK_KARSILIKSIZ,
		SENET_ODENMEDI,
		SENET_KARSILIKSIZ,
		FORWARD_SALE_LIMIT,
		OPEN_ACCOUNT_RISK_LIMIT,
		PAYMENT_BLOKAJ,
		TOTAL_RISK_LIMIT,
		SECURE_TOTAL_TAKE,
		SECURE_TOTAL_GIVE,
		COMPANY_ID
	FROM 
		COMPANY_RISK
	WHERE 
		COMPANY_ID = #attributes.company_id#
</cfquery>
<cf_grid_list>
	<cfif GET_COMPANY_RISK.recordcount>
		<cfoutput>
			<cf_seperator title="#getLang('','Finansal Özet','58085')#" id="financial_summary">
			<cf_flat_list id="financial_summary">
				<tr class="bold" height="22">
					<td class="bold" width="25%"><cf_get_lang dictionary_id='57872.Toplam Risk'></td>
					<td width="24%"  class="bold" style="text-align:right;">
					#TLFormat(GET_COMPANY_RISK.BAKIYE - (GET_COMPANY_RISK.CEK_ODENMEDI + GET_COMPANY_RISK.SENET_ODENMEDI + GET_COMPANY_RISK.CEK_KARSILIKSIZ + GET_COMPANY_RISK.SENET_KARSILIKSIZ))# #session.ep.money#
					<!--- Açik Hesap +  Ödenmemiş çek + ödenmemiş senet + KARŞILIKSIZ --->
					</td>
					<td class="color-row" rowspan="8" width="2%"></td>
					<td class="bold" width="25%"><cf_get_lang dictionary_id="57878.Kullanılabilir Limit"></td>
					<td width="24%"  class="bold" style="text-align:right;">
					#TLFormat( GET_COMPANY_RISK.TOTAL_RISK_LIMIT - GET_COMPANY_RISK.BAKIYE  - (GET_COMPANY_RISK.CEK_ODENMEDI + GET_COMPANY_RISK.SENET_ODENMEDI + GET_COMPANY_RISK.CEK_KARSILIKSIZ + GET_COMPANY_RISK.SENET_KARSILIKSIZ))# #session.ep.money#
					<!---(Acik hesap limit - açik hesap)+(vadeli ödeme araci limit - (ödenmemiş çek + ödenmemiş senet) --->
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='32737.Açık Hesaplar'></td>
					<td  style="text-align:right;"><cfif GET_COMPANY_RISK.BAKIYE gt 0><strong>(B)</strong><cfelse><strong>(A)</strong></cfif>
					#TLFormat(GET_COMPANY_RISK.BAKIYE)# #session.ep.money#
					<!--- Üye şirkete borç alacakda bakiye veren rakam--->
					</td>
					<td><cf_get_lang dictionary_id="32987.Kullanılabilir Açık Hesap"></td>
					<td  style="text-align:right;">
						#TLFormat(GET_COMPANY_RISK.OPEN_ACCOUNT_RISK_LIMIT - GET_COMPANY_RISK.BAKIYE)# #session.ep.money#
					<!--- Üye şirkete kredi durumunda yazan açik hesap limiti -(eksi) açik hesap toplami arasindaki fark --->
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57522.Çek Senet'></td>
					<td  style="text-align:right;">
					#TLFormat(GET_COMPANY_RISK.CEK_ODENMEDI + GET_COMPANY_RISK.SENET_ODENMEDI)# #session.ep.money# 
					<!--- Uye sirketten aldigimiz vadesi gelmemis durumundaki cek-senet toplami --->
					</td>
					<td><cf_get_lang dictionary_id="32985.Kullanılabilir Çek Senet"></td>
					<td  style="text-align:right;">
					#TLFormat(GET_COMPANY_RISK.FORWARD_SALE_LIMIT - (GET_COMPANY_RISK.CEK_ODENMEDI + GET_COMPANY_RISK.SENET_ODENMEDI + GET_COMPANY_RISK.CEK_KARSILIKSIZ + GET_COMPANY_RISK.SENET_KARSILIKSIZ))# #session.ep.money#
					<!--- Üye şirkete kredi durumunda yazan vedeli ödeme araci limiti  - ödenmemiş çek ve senet toplami arasindaki fark --->
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='32861.Karşılıksız'></td>
					<td  style="text-align:right;">
					#TLFormat(GET_COMPANY_RISK.CEK_KARSILIKSIZ + GET_COMPANY_RISK.SENET_KARSILIKSIZ)# #session.ep.money# 
					<!--- Uye sirketin verdigi ve karsiliksiz durumundaki cek-senet toplami --->
					</td>
					<td><cf_get_lang dictionary_id='32926.Ödeme Blokajı'></td>
					<td  style="text-align:right;">
					#TLFormat(GET_COMPANY_RISK.PAYMENT_BLOKAJ)# #session.ep.money#
					</td>
				</tr>
				<tr  height="20">
					<td class="bold"><cf_get_lang dictionary_id='57877.Toplam Limit'></td>
					<td  class="bold" style="text-align:right;"> #TLFormat(GET_COMPANY_RISK.TOTAL_RISK_LIMIT)# #session.ep.money#
					<!--- (Acik hesap limit - açik hesap)+(vadeli ödeme araci limit - (ödenmemiş çek + ödenmemiş senet) --->
					</td>
					<td class="bold"><cf_get_lang dictionary_id='33045.Teminat Farkı'></td>
					<td  class="bold" style="text-align:right;">
						#tlformat(GET_COMPANY_RISK.SECURE_TOTAL_TAKE - GET_COMPANY_RISK.SECURE_TOTAL_GIVE)# #session.ep.money#
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57875.Açık Hesap Limiti'></td>
					<td  style="text-align:right;"> #TLFormat(GET_COMPANY_RISK.OPEN_ACCOUNT_RISK_LIMIT)# #session.ep.money#
					</td>
					<td><cf_get_lang dictionary_id='33043.Alınan Teminatlar'></td>
					<td  style="text-align:right;">
					#TLFORMAT(GET_COMPANY_RISK.SECURE_TOTAL_TAKE)# #session.ep.money#
					<!---Alinan Teminatlarin bitiş süresi bugünden en az 30 gün sonra olanlarin toplami --->
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57876.Çek Senet Limiti'></td>
					<td  style="text-align:right;">
					#TLFormat(GET_COMPANY_RISK.FORWARD_SALE_LIMIT)# #session.ep.money#
					<!--- Üye şirkete kredi durumunda yazan vedeli ödeme araci limiti  - ödenmemiş çek ve senet toplami arasindaki fark --->
					</td>
					<td><cf_get_lang dictionary_id='33044.Verilen Teminatlar'></td>
					<td  style="text-align:right;">#tlformat(GET_COMPANY_RISK.SECURE_TOTAL_GIVE)# #session.ep.money#</td>
				</tr>
			</cf_flat_list>
		</cfoutput>
	<cfelse>
		<cf_flat_list id="financial_summary">
			<tr  height="20">
				<td colspan="5" class="txtbold"><cf_get_lang dictionary_id="32991.Üye Risk Limitleri Tanımlı Değil">! <cf_get_lang dictionary_id="32993.Lütfen Tanımlayınız">!</td>
			</tr>
		</cf_flat_list>
	</cfif>
</cf_grid_list>

