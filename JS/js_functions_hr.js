/*
    HR Modulü genel JS fonksiyonları
    Esma R. Uysal
*/
//Çalışanın vardiyası var mı kontrolü yapıp haftasonu selectini gösterir
function employee_shift_control(employee_id) {
    $.ajax({
        type:"post",
        url: "/V16/hr/cfc/get_employee_shift.cfc?method=GET_SHIF_EMPLOYEES_IN_OUT_JSON&employee_id="+employee_id,
        success: function(dataread) {
            if(parseInt(dataread) > 0)
            {
                document.getElementById("item-WEEK_OFFDAY").style.display='';
            }
            else{
                document.getElementById("item-WEEK_OFFDAY").style.display='none';
            }
        },
        error: function(xhr, opt, err)
        {
            alert(err.toString());
        }
    });
}

//Çalışan vardiyalı mı kontrolü yapılıktan sonra belirtilen gün içeridinde vardiyası var mı yok mu kontrol eder.
function shift_holiday_control(employe_id, startdate,finishdate)
{
    is_shift_holiday = 0;
    $.ajax({ 
        type:'POST',  
        async:false,
        url:'V16/hr/cfc/get_employee_shift.cfc?method=GET_SHIF_EMPLOYEES_IN_OUT_JSON',  
        data: {employee_id : employe_id},
        success: function (response) { 
            if(response >= 1)
            {
                $.ajax({ 
                    type:'POST', 
                    async:false, 
                    url:'V16/hr/cfc/get_employee_shift.cfc?method=get_emp_shift_json',  
                    data: {
                        employee_id : employe_id,
                        start_date : startdate,
                        finish_date : finishdate
                    },
                    success: function (response2) { 
                        var response2_ = JSON.parse(response2); 
                        if(response2_['DATA'].length == 0)
                            is_shift_holiday = 1;
                        else
                            is_shift_holiday = 2;
                    }
                });
            }
    }});
    return is_shift_holiday;
}
