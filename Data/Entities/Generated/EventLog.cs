using System;
using System.Collections.Generic;

namespace Data.Entities
{
    public partial class EventLog
    {
        public Guid Id { get; set; }
        public DateTime EventDate { get; set; }
        public string? Description { get; set; }
    }
}
