<script language="javascript1.3">

var js_money_ayrac_binlik = ',';
var js_money_ayrac_ondalik = '.';


function filterNumBasket(str,no_of_decimal) 
{
	if (str == undefined || str.length == 0) return '';
	if(!no_of_decimal && no_of_decimal!=0)
		no_of_decimal=2;
	while(str.indexOf(js_money_ayrac_binlik) > 0) str = str.replace(js_money_ayrac_binlik,'');
	//str = str.replace(',', '.');
	decimal_carpan = Math.pow(10,no_of_decimal);
	if(str!=0) return (Math.round(str*decimal_carpan)/decimal_carpan);
	else return  0;
}
</script>
