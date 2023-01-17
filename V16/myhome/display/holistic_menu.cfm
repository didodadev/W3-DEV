<cfparam name="attributes.solution" default="">
<cfparam name="attributes.family" default="">
<cfparam name="attributes.module" default="">
<script src="/JS/assets/plugins/menuDesigner/vue.js"></script>
<script src="/JS/assets/plugins/menuDesigner/axios.min.js"></script>
<link rel="stylesheet" href="V16/myhome/display/holistic_menu/index.css">


<div id="jelibon-menu" class="row holistic_container">   
    <div class="row">
        <input type="text" v-model="keyword"/>
    </div>
    <div class="holistic_box" v-if="keyword.length == 0">
        <div class="box_title">
            <a class="all_list" href="javascript://" @click="show_menu('solition',0)"><i class="icon-angle-right"></i> Uygulamalar </a>
            <a class="all_list" href="javascript://" v-if="solution_title" @click="show_menu('family', solution_id)"><i class="icon-angle-right"></i> {{solution_title}} </a>
            <a class="all_list" href="javascript://" v-if="family_title" @click="show_menu('module', family_id)"><i class="icon-angle-right"></i> {{family_title}} </a>
            <a class="all_list" href="javascript://" v-if="module_title" ><i class="icon-angle-right"></i> {{module_title}} </a>
        </div>
        <div class="box_icon" v-if="show_type == 'solition'">            
            <div class="box_icon_item" v-for="(item,name) in solution">
                <div class="item_box" @click="show_menu('family',item[0].WRK_SOLUTION_ID)">                        
                    <i :class="'iconBoxes font-style-normal ' + item[0].SOLUTION_ICON" v-if="item[0].SOLUTION_ICON"></i>
                    <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.noIcon(name)]" v-else>{{name | first}}</i>                        
                    <i class="icon-title" style="text-align:center;">{{name}}</i>
                </div>
            </div>         
        </div>
        <div class="box_icon" v-if="show_type == 'family'">
            <div class="box_icon_item" v-for="(item,name) in family">
                <div class="item_box" @click="show_menu('module',item[0].WRK_FAMILY_ID)">                         
                    <i :class="'iconBoxes font-style-normal ' + item[0].FAMILY_ICON" v-if="item[0].FAMILY_ICON"></i>
                    <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(name)]" v-else>{{name | first}}</i>                        
                    <i class="icon-title" style="text-align:center;">{{name}}</i>
                    <i v-show="false">{{solution_title=item[0].SOLUTION_TITLE}} {{solution_id=item[0].WRK_SOLUTION_ID}}</i>
                </div>
            </div>  
        </div>
        <div class="box_icon" v-if="show_type == 'module'">
            <div class="box_icon_item" v-for="(item,name) in modules">
                <div class="item_box" @click="show_menu('object',item[0].MODULE_NO)">                        
                    <i :class="'iconBoxes font-style-normal ' + item[0].MODULE_ICON" v-if="item[0].MODULE_ICON"></i>
                    <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(name)]" v-else>{{name | first}}</i>                        
                    <i class="icon-title" style="text-align:center;">{{name}}</i>
                    <i v-show="false">{{solution_title=item[0].SOLUTION_TITLE}} {{solution_id=item[0].WRK_SOLUTION_ID}}</i>
                    <i v-show="false">{{family_title=item[0].FAMILY_TITLE}} {{family_id=item[0].WRK_FAMILY_ID}}</i>
                </div>
            </div>
        </div>
        <div class="box_icon" v-if="show_type == 'object'">
            <div class="box_icon_item" v-for="(item,name) in objects">
                <a :data-fuseaction="item.FUSEACTION" :href="'/index.cfm?fuseaction='+item.FUSEACTION">                        
                    <i :class="'iconBoxes font-style-normal ' + item.OBJECT_ICON" v-if="item.OBJECT_ICON"></i>
                    <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(item.OBJECT_TITLE)]" v-else>{{item.OBJECT_TITLE | first}}</i>                        
                    <i class="icon-title" style="text-align:center;">{{item.OBJECT_TITLE}}</i>
                    <i v-show="false">{{solution_title=item.SOLUTION_TITLE}} {{solution_id=item.WRK_SOLUTION_ID}}</i>
                    <i v-show="false">{{family_title=item.FAMILY_TITLE}} {{family_id=item.WRK_FAMILY_ID}}</i>
                    <i v-show="false">{{module_title=item.MODULE_TITLE}} {{module_id=item.MODULE_NO}}</i>
                </a>
            </div>
        </div>
    </div>
    <div class="holistic_box" v-else>
        <div class="box_icon">
            <div class="box_icon_item" v-for="(item,name) in filtered">
                <a :data-fuseaction="item.FUSEACTION" :href="'/index.cfm?fuseaction='+item.FUSEACTION">                        
                    <i :class="'iconBoxes font-style-normal ' + item.OBJECT_ICON" v-if="item.OBJECT_ICON"></i>
                    <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(item.OBJECT_TITLE)]" v-else>{{item.OBJECT_TITLE | first}}</i>                        
                    <i class="icon-title" style="text-align:center;">{{item.OBJECT_TITLE}}</i>
                </a>
            </div>
        </div>
    </div>
</div>
<script>
    var wjm = new Vue({
        el: '#jelibon-menu',
        data: {
            menuJson: [],
            solution: [],
            family : [],
            modules : [],
            objects : [], 
            solution_title : false,
            family_title : false,
            module_title : false,
            solution_id : 0,
            family_id : 0,
            module_id : 0,
            keyword : '',
            show_type : 'solition',         
            error: []
        },
        methods: {            
            group: function (xs, key) {
                if(xs){
                    return xs.reduce(function(rv, x) {
                        (rv[x[key]] = rv[x[key]] || []).push(x);
                        return rv;
                    }, {});
                }else{
                    return [];
                }
            },
            show_menu: function (type,id){
                me = this;
                console.log(id + ' -- ' + type);
                switch(type) {
                    case 'solition':
                        this.show_type = "solition";
                        me.solution_id = id;
                        me.family_title = false;
                        me.solution_title = false;
                        me.module_title = false;
                    break;
                    case 'family':
                        this.show_type = "family"; 
                        var family_list = me.group(me.menuJson,"WRK_SOLUTION_ID")[id];
                        me.family = me.group(family_list,"FAMILY_TITLE");
                        me.solution_id = id;
                        me.family_title = false;
                        me.modul_title = false;
                    break;
                    case 'module':
                        this.show_type = "module";
                        var module_list = me.group(me.menuJson,"WRK_FAMILY_ID")[id];
                        me.modules = me.group(module_list,"MODULE_TITLE");
                        me.family_id = id; 
                        me.module_title = false;
                    break;
                    case 'object':
                        this.show_type = "object";
                        me.objects = me.group(me.menuJson,"MODULE_NO")[id];
                    break;
                };
            }
        },
        filters: {
            noIcon: function (value) {
            if (!value) return ''
            value = value.toString()
            return value.substring(0,2).toUpperCase();
            },
            first: function (value) {
            if (!value) return ''
            value = value.toString()
            return value.substring(0,1).toUpperCase();
            }         
        },
        mounted () {
            me = this;
            axios
                .get( "<cfoutput>#file_web_path#personal_settings/userGroup_jelibon_menu_#session.ep.language#_#GET_USER_GROUP_MENU#.json</cfoutput>")
                .then(function (response) { 
                    me.menuJson = response.data['DATA'];
                    me.solution = me.group(response.data['DATA'],'SOLUTION_TITLE');
                    <cfif len(attributes.solution) neq 0>
                        me.show_menu('family',<cfoutput>#attributes.solution#</cfoutput>);
                    <cfelseif len(attributes.family) neq 0>
                        me.show_menu('module',<cfoutput>#attributes.family#</cfoutput>);
                        <cfelseif len(attributes.module) neq 0>
                        me.show_menu('object',<cfoutput>#attributes.module#</cfoutput>);

                    </cfif>  
                })
                .catch(function (error) {console.log(error); }); 
                
        },
        computed: {
            filtered: function () {

                var source = this.menuJson;
                var keyword = this.keyword;

                if(!keyword){
                return source;
                }

                searchString = keyword.trim().toLowerCase();

                source = source.filter(function(item){
                if(item.OBJECT_TITLE.toLowerCase().indexOf(keyword) !== -1){
                    return item;
                }
                })
                console.log(source);
                return source;
            }
        }
    })
</script> 