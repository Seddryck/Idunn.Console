using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Idunn.Core.Template.StringTemplate
{
    public interface ITemplateFactoryRegister<T>
    {
        ITemplateFactory<T> GetFactory();
    }
}
