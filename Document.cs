using portdic;

namespace wapis.Model
{
    public class IOModel
    {
        /// <summary>
        /// 
        /// </summary>
        [ColumnHeader, EntryProperty]
        public string Pin_No { set; get; } = string.Empty;
        /// <summary>
        /// 
        /// </summary>
        [ColumnHeader, EntryProperty]
        public string Port_NO { set; get; } = string.Empty;
        /// <summary>
        /// 
        /// </summary>
        [ColumnHeader, EntryKey]
        public string Description { set; get; } = string.Empty;
        /// <summary>
        /// 
        /// </summary>
        [ColumnHeader, EntryProperty]
        public string Model { set; get; } = string.Empty;
        /// <summary>
        /// 
        /// </summary>
        [ColumnHeader, EntryProperty]
        public string Bit_On { set; get; } = string.Empty;

        private string _datatype = "enum.OffOn";
        /// <summary>
        /// 
        /// </summary>
        [EntryDataType]
        public string DataType
        {
            set
            {
                _datatype = value;
            }
            get
            {
                return _datatype;
            }
        }
    }


    [Document(@"D:\PORT\SampleArduinoLib\wapis\port\MT-30T IO_Map Ver2.2.docx")]
    public class IODocument
    {
        [Save("D:\\PORT\\SampleArduinoLib\\wapis\\port\\device\\io.page", "D:\\PORT\\SampleArduinoLib\\wapis\\port\\io1.cs")]
        public Document<IOModel> Convert(Document<IOModel> doc)
        {
            doc.ForEach(v => v.DataType = "enum.OffOn");
            doc.ForEach(v => v.Package = "DigitalIO.DI");
            return doc;
        }
    }

}
