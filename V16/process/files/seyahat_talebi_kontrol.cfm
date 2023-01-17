<!---
    Author: Workcube - Gülbahar Inan <gulbaharinan@workcube.com>
    Date: 12.03.2020
    Description:
	Seyahat Talebi Pozisyon Kontrol Etmek için yazılmıştır.
--->
<script type="text/javascript">
    function process_cat_dsp_function()
    {
        var position_cat_list = '9'; //GMY,GM,YK,YKÜ pozisyonlarının Idleri 
        position_code_ = document.travel_demand.position_code.value; 
        param_list=position_code_+'*'+ position_cat_list;
        var get_position_cat = wrk_safe_query('get_position_cat','dsn',0,param_list);
        if(get_position_cat.recordcount == 0)
        {
            $('#flight_class_demand').on('change', function() {
                if ($("#flight_class_demand").val() == 1)
                {
                    alert('Business Class Seçmeye Yetkiniz Yoktur.')
                    $("#flight_class_demand").val(2);
                }
		    });
        }
        if(get_position_cat.recordcount == 0)
        {
            $('#is_departure_fee2').prop("checked", true);
			$('input:radio[name="is_departure_fee"]').change(
            function(){
                if ($(this).is(':checked')) {
                    if($(this).attr('id')=='is_departure_fee1') 
                    {
                        alert('GMY ve üzeri pozisyonlar için yurtdışı çıkış harcı ödenmektedir !');
                        $('#is_departure_fee2').prop("checked", true);
                    }
                    
                }
		});
        }
    }
</script>
    
