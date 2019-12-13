<p>

    <span class="u-margin-right-s" id="login" style="display: none;">
        <a href="{"/user/login"|ezurl(no)}"
           title="{"Login"|i18n("design/standard/layout")}">{"Login"|i18n("design/standard/layout")}</a>
    </span>

  {if and(ezmodule( 'user/register' ), fetch( 'user', 'has_access_to', hash( 'module', 'user', 'function', 'register' ) ))}
    <span class="u-margin-right-s" id="registeruser" style="display: none;">
            <a href="{"/user/register"|ezurl(no)}"
               title="{'Not registered?'|i18n( 'design/standard/toolbar' )}">{'Not registered?'|i18n( 'design/standard/toolbar' )}</a>
        </span>
  {/if}

</p>


<script>{literal}
    $(document).ready(function(){        
        {/literal}
        var accessPath = "{''|ezurl(no,full)}";
        var dashboardString = "{'Dashboard'|i18n('design/admin/content/dashboard')}";
        var profileString = "{'My profile'|i18n('design/ocbootstrap/pagelayout')}";
        {literal}
        var login = $('#login');
        login.find('a').attr('href', login.find('a').attr('href') + '?url='+ ModuleResultUri);
        var register = $('#registeruser');
        login.attr('href', login.attr('href') + '?url='+ ModuleResultUri);
        var injectUserInfo = function(data){
            if(data.error_text || !data.content){
                login.show();
                register.show();
            }else{
                login.after('<span class="u-margin-right-s" id="myprofile"><a href="'+accessPath+'/user/edit/" title="'+profileString+'">'+profileString+'</a></span><span class="u-margin-right-s" id="logout"><a href="'+accessPath+'/user/logout" title="Logout">Logout ('+data.content.name+')</a></span>');
                if(data.content.has_access_to_dashboard){
                    login.after('<span class="u-margin-right-s"><a href="'+accessPath+'/content/dashboard/" title="'+dashboardString+'">'+dashboardString+'</a></span>');
                }
                login.remove();
                register.remove();
            }
        };
        if(CurrentUserIsLoggedIn){
            $.ez('openpaajax::userInfo', null, function(data){
                injectUserInfo(data);
            });
        }else{
            login.show();
            register.show();
        }
    });
    {/literal}</script>
