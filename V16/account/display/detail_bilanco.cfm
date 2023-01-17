<!--- bilanco (mali tablolara) ilişkin detaylar 20130320
	Cari Oran  = Dönen Varlıklar (A.01) / Kısa Vadeli Borçlar (P.01) 
	Net İşletme Sermayesi  = Dönen Varlıklar (A.01)- Kısa Vadeli Borçlar (P.01) 
	Likitide Oranı  = [Dönen Varlıklar (A.01) - Stoklar (A.01.E) ] / Kısa Vadeli Borçlar (P.01) 
	Kaldıraç Oranı  = Toplam Yabancı Kaynaklar (P.01 + P.02) / Toplam Varlıklar (A.01 + A.02)  
	Borçların Öz Sermayeye Oranı  = Yabancı Kaynaklar (P.01 + P.02) / Öz Sermaye (P.03) 
--->
<cf_box title='#getlang(328,'Mali Analizler',59296)#' popup_box="1">
	<cf_flat_list>
		<cfoutput>
			<tr>
				<td><cf_get_lang dictionary_id="34007.Cari Oran"></td>
				<td class="txtbold">=</td>
				<td class="txtbold"> A.01 / P.01 </td>
				<td class="txtbold">=</td>
				<td>(#attributes.donen_varliklar#) / (#attributes.kisa_vadeli_yabanci#)</td>
				<cfif filternum(attributes.kisa_vadeli_yabanci) neq 0>
					<td class="txtbold">=</td>
					<td>#tlFormat(filternum(attributes.donen_varliklar)/filternum(attributes.kisa_vadeli_yabanci))#</td>
				</cfif>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="33939.Net İşletme Sermayesi"></td>
				<td class="txtbold">=</td>
				<td class="txtbold"> A.01 - P.01 </td>
				<td class="txtbold">=</td>
				<td>(#attributes.donen_varliklar#) - (#attributes.kisa_vadeli_yabanci#)</td>
				<td class="txtbold">=</td>
				<td>#tlFormat(filternum(attributes.donen_varliklar)-filternum(attributes.kisa_vadeli_yabanci))#</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="34157.Likitide Oranı"></td>
				<td class="txtbold">=</td>
				<td class="txtbold"> (A.01 -  A.01.E) / P.01 </td>
				<td class="txtbold">=</td>
				<td>[(#attributes.donen_varliklar#) - (#attributes.stoklar#)] / (#attributes.kisa_vadeli_yabanci#)</td>
				<cfif filternum(attributes.kisa_vadeli_yabanci) neq 0>
					<td class="txtbold">=</td>
					<td>#tlFormat((filternum(attributes.donen_varliklar)-filternum(attributes.stoklar))/filternum(attributes.kisa_vadeli_yabanci))#</td>
				</cfif>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="34156.Kaldıraç Oranı"></td>
				<td class="txtbold">=</td>
				<td class="txtbold"> (P.01 + P.02) / (A.01 + A.02) </td>
				<td class="txtbold">=</td>
				<td>[(#attributes.kisa_vadeli_yabanci#) + (#attributes.uzun_vadeli_yabanci#)] / [(#attributes.donen_varliklar#) + (#attributes.duran_varliklar#)]</td>
				<cfif (filternum(attributes.donen_varliklar)+filternum(attributes.duran_varliklar)) neq 0>
					<td class="txtbold">=</td>
					<td>#tlFormat((filternum(attributes.kisa_vadeli_yabanci)+filternum(attributes.uzun_vadeli_yabanci))/(filternum(attributes.donen_varliklar)+filternum(attributes.duran_varliklar)))#</td>
				</cfif>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="34155.Borçların Öz Sermayeye Oranı"> </td>
				<td class="txtbold">=</td>
				<td class="txtbold"> (P.01 + P.02) / P.03 </td>
				<td class="txtbold">=</td>
				<td>[(#attributes.kisa_vadeli_yabanci#) + (#attributes.uzun_vadeli_yabanci#)] / (#attributes.ozsermaye#)</td>
				<cfif filternum(attributes.ozsermaye) neq 0>
					<td class="txtbold">=</td>
					<td>#tlFormat((filternum(attributes.kisa_vadeli_yabanci)+filternum(attributes.uzun_vadeli_yabanci))/filternum(attributes.ozsermaye))#</td>
				</cfif>
			</tr>
		</cfoutput>
	</cf_flat_list>
</cf_box>

