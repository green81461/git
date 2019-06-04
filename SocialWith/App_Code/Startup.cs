using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(SocialWith.Startup))]
namespace SocialWith
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
