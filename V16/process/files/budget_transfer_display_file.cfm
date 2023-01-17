<!---
    Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
    Date: 16.01.2021
    Description:Bütçe aktarım talebi kayıt oluşturuken kayıt yapan kişinin pozisyon id sine göre süreçlere gider
      .--->
<script type="text/javascript">
    process_cat_dsp_function = function() {
        var employee_id = $('#employee_id').val();
        var exp_center_1 = $('#acc_control_1_1').val();
        var exp_center_2 = $('#acc_control_1_2').val();
        var sql = "SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID ="+ employee_id;
        console.log(sql);
        get_position_id = wrk_query(sql,'dsn');
        if(list_find('30,11,3,9',get_position_id.POSITION_ID,',')==0){
            console.log(exp_center_1);
            $("#process_stage").val(167);/* talep eden çalışan kayıt */
        }
        else if (list_find('30', get_position_id.POSITION_ID,',')){
            console.log(exp_center_1);
            $("#process_stage").val(169);/* talep eden direktör onayında */
        }
        else if (list_find('11,3,9', get_position_id.POSITION_ID,',')){
            if (exp_center_1 == exp_center_2){
                console.log(exp_center_1);
                $("#process_stage").val(171);/* finans rap bölüm personeli */
            }
            else {
                $("#process_stage").val(170);/* talep edilen bölüm personeli */
            }     
        }
    return true;
    }
</script>