<cfscript>
/* eskiden stajyer cirak ve mesleki stajyere vergi hesaplamiyorduk simdi hesapliyoruz yo17092009
if (get_hr_ssk.SSK_STATUTE eq 3 or get_hr_ssk.SSK_STATUTE eq 4 or get_hr_ssk.SSK_STATUTE eq 75)//stajyer
	{
	gelir_vergisi_matrah = 0;
	gelir_vergisi = 0;
	tax_ratio = 0;
	}
else
*/
{
	gelir_vergisi = 0;
	tax_ratio = get_active_tax_slice.RATIO_1;
	s1 = get_active_tax_slice.MAX_PAYMENT_1;	v1 = get_active_tax_slice.RATIO_1 / 100;
	s2 = get_active_tax_slice.MAX_PAYMENT_2;	v2 = get_active_tax_slice.RATIO_2 / 100;
	s3 = get_active_tax_slice.MAX_PAYMENT_3;	v3 = get_active_tax_slice.RATIO_3 / 100;
	s4 = get_active_tax_slice.MAX_PAYMENT_4;	v4 = get_active_tax_slice.RATIO_4 / 100;
	s5 = get_active_tax_slice.MAX_PAYMENT_5;	v5 = get_active_tax_slice.RATIO_5 / 100;
	s6 = get_active_tax_slice.MAX_PAYMENT_6;	v6 = get_active_tax_slice.RATIO_6 / 100;
	
	all_ = kumulatif_gelir + gelir_vergisi_matrah;
	
	if (kumulatif_gelir gte s5)
		{
		gelir_vergisi = gelir_vergisi + (gelir_vergisi_matrah * v6);
		}
	else if (kumulatif_gelir gte s4)
		{
		if (all_ gte s5)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
			gelir_vergisi = gelir_vergisi + ((s5 - kumulatif_gelir) * v5);
			}
		else
			gelir_vergisi = gelir_vergisi + (gelir_vergisi_matrah * v5);
		}
	else if (kumulatif_gelir gte s3)
		{
		if (all_ gte s5)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
			gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - kumulatif_gelir) * v4);
			}
		else if (all_ gte s4)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - kumulatif_gelir) * v4);
			}
		else
			gelir_vergisi = gelir_vergisi + (gelir_vergisi_matrah * v4);
		}
	else if (kumulatif_gelir gte s2)
		{
		if (all_ gte s5)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
			gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - kumulatif_gelir) * v3);
			}
		else if (all_ gte s4)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - kumulatif_gelir) * v3);
			}
		else if (all_ gte s3)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - kumulatif_gelir) * v3);
			}
		else
			gelir_vergisi = gelir_vergisi + (gelir_vergisi_matrah * v3);
		}
	else if (kumulatif_gelir gte s1)
		{
		if (all_ gte s5)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
			gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
			}
		else if (all_ gte s4)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
			}
		else if (all_ gte s3)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
			}
		else if (all_ gte s2)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
			}
		else
			gelir_vergisi = gelir_vergisi + (gelir_vergisi_matrah * v2);
		}
	else
		{
		if (all_ gte s5)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
			gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
			gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
			}
		else if (all_ gte s4)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
			gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
			}
		else if (all_ gte s3)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
			gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
			}
		else if (all_ gte s2)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
			gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
			}
		else if (all_ gte s1)
			{
			gelir_vergisi = gelir_vergisi + ((all_ - s1) * v2);
			gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
			}
		else
			gelir_vergisi = gelir_vergisi + (gelir_vergisi_matrah * v1);
		}
	
	if (gelir_vergisi_matrah)
		tax_ratio = (gelir_vergisi / gelir_vergisi_matrah);
	else
		tax_ratio = 0; // AK20040806 30 gün ücretsiz izni var ise
}
</cfscript>
