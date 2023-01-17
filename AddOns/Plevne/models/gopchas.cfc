
component extends="AddOns.Plevne.infrastructure.modelbase" {
    
    
    public string function get_gopcha_key(string user_id, string ip, string unusedis) {
        
        inst_gopcha = super.resolveObject("#addonns#.domains.gopchas");
        inst_gopcha.delete_gopcha(remove_expired: 1);
        gopcha = inst_gopcha.get_gopchas(user_id: arguments.user_id, ip: arguments.ip, unusedis: arguments.unusedis);
        if (gopcha.recordcount) {
            return gopcha.GOPCHA_KEY;
        } else {
            return "";
        }
    }
 
    public struct function generate_gopcha_key(string user_id, string ip) {
        gopcha_key = createUUID();
        gopcha_code = int(rand() * 1000000);
        employee = super.resolveObject("Utility.getEmployeeInfo").get(arguments.user_id);
        address = "0#employee.MOBILCODE##employee.MOBILTEL#";
        super.resolveObject("#addonns#.domains.gopchas").save_gopcha(0, arguments.user_id, 1, gopcha_key, gopcha_code, address, now(), arguments.ip);

        inst_sms = createObject('component', 'WEX.sitetour.hooks.sms');
        inst_sms_ =createObject('component','WMO.functions');
        sms_data = {};
        sms_data.tel = address;
        sms_data.message = "#inst_sms_.getLang('','Wokcube Plevne MFA kodunuz','63754';)#" :  & gopcha_code;
        inst_sms.send_sms(sms_data);

        return { gopcha_key: gopcha_key, gopcha_code: gopcha_code, address: address };
    }

    public any function remove_gopcha_key(string key) {
        super.resolveObject("#addonns#.domains.gopchas").delete_gopcha(gopcha_key: key);
    }

    public string function get_gopcha_code(string user_id, string ip, string gopcha_code) {
        super.resolveObject("#addonns#.domains.gopchas").get_gopchas(user_id: arguments.user_id, ip: arguments.ip, gopcha_code: arguments.gopcha_code);
    }

    public any function update_gopcha_until(string key, any until) {
        super.resolveObject("#addonns#.domains.gopchas").save_gopcha(gopcha_id: 1, gopcha_key: arguments.key, gopcha_until: arguments.until, user_id: session.ep.userid);
    }

}