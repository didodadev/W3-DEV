<cf_date tarih="attributes.vade_tarihi">
<cf_date tarih="attributes.evrak_tarihi">
<cfif isdefined("attributes.islem_tarihi")>
    <cf_date tarih="attributes.islem_tarihi">
</cfif>
<cfset new_tarih_ = dateadd('d',attributes.uzatma_gun,attributes.vade_tarihi)>
<cfset odeme_tarihi_ = new_tarih_>
<cfif dayofweek(odeme_tarihi_) neq 7>
	<cfset odeme_tarihi_ = dateadd('d',(7 - dayofweek(odeme_tarihi_)),new_tarih_)>
</cfif>
<cfset attributes.islem_tarihi_formatli = "#attributes.startdate#">
<cfoutput>
	<script>
        document.getElementById('uzatma_tarih#attributes.row_id#').value = '#dateformat(new_tarih_,"dd/mm/yyyy")#';
		document.getElementById('odeme_gunu_tarih#attributes.row_id#').value = '#dateformat(odeme_tarihi_,"dd/mm/yyyy")#';
		document.getElementById('son_vade_gun#attributes.row_id#').value = '#datediff("d",attributes.evrak_tarihi,odeme_tarihi_)#';
		document.getElementById('vade_asimi#attributes.row_id#').value = '#datediff("d",attributes.vade_tarihi,odeme_tarihi_)#';
		<cfif isdefined("attributes.islem_tarihi")>
			document.getElementById('islem_tar_vade#attributes.row_id#').value = '#datediff("d",attributes.islem_tarihi,odeme_tarihi_)#';
		</cfif>
		
		company_id_ = document.getElementById('company_id#attributes.row_id#').value;
		
		
		rel_ = "comp_rel='bakiye" + company_id_ + "'";
		cols = $("input[" + rel_ + "]");
		eleman_sayisi_ = cols.length;
		
		rel2_ = "comp_rel='odeme_gunu_tarih" + company_id_ + "'";
		cols2 = $("input[" + rel2_ + "]");
		
		if(eleman_sayisi_ > 1)
		{
			grand_o_total = 0;
			grand_o_base_total = 0;
			for (var i=0; i < eleman_sayisi_; i++)
            {
				fark_ = datediff('#attributes.islem_tarihi_formatli#',cols2[i].value,0);
				grand_o_base_total = grand_o_base_total + (parseFloat(filterNum(cols[i].value)) * fark_);
				grand_o_total = grand_o_total + parseFloat(filterNum(cols[i].value));
			}
			document.getElementById('t_bakiye' + company_id_).value = commaSplit(grand_o_total);
			ortalama_odeme_gunu_ = wrk_round(grand_o_base_total / grand_o_total,0);
            ortalama_odeme_tarihi_ = date_add('d',ortalama_odeme_gunu_,'#attributes.islem_tarihi_formatli#');
			document.getElementById('t_odeme_gunu_tarih' + company_id_).value = ortalama_odeme_tarihi_;
			
			document.getElementById('t_son_vade_gun' + company_id_).value = datediff('#dateformat(attributes.evrak_tarihi,"dd/mm/yyyy")#',ortalama_odeme_tarihi_,0);
            document.getElementById('t_vade_asimi' + company_id_).value = datediff('#dateformat(attributes.vade_tarihi,"dd/mm/yyyy")#',ortalama_odeme_tarihi_,0);
		}
    	<cfif attributes.type eq 1>
			setTimeout(function(){hesapla_table()}, 1500);
		</cfif>
    </script>
</cfoutput>