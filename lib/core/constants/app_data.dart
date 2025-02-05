import 'package:flutter/material.dart';

var colorAccentArray = [
  Colors.deepPurpleAccent,
  Colors.pinkAccent,
  Colors.redAccent,
  Colors.orangeAccent,
];

var colorArray = [
  Colors.deepPurple,
  Colors.pink,
  Colors.red,
  Colors.orange,
];

final List<Color> accentColors = [
  Colors.deepPurpleAccent,
  Colors.redAccent,
  Colors.orangeAccent,
  Colors.blueAccent,
  Colors.pinkAccent,
  Colors.amberAccent,
  Colors.green,
  Colors.purpleAccent,
];

var timeTable = {
  "Monday": [
    {
      "sTime": "9:00",
      "eTime": "10:00",
      "subject": "Monday",
      // "subject": "AOA",
      "teacher": "Dr. Amiya",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "10:00",
      "eTime": "11:00",
      "subject": "Python",
      "teacher": "Shainila",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "13:15",
      "subSlots": [
        {
          "subject": "MP LAB",
          "batch": "A",
          "teacher": "Sejal",
          "location": "CC-1",
        },
        {
          "subject": "AOA LAB",
          "batch": "B",
          "teacher": "Dr. Amiya",
          "location": "CC-2",
        },
        {
          "subject": "OS Lab",
          "batch": "C",
          "teacher": "Dipti",
          "location": "CL-3",
        }
      ],
      "type": "PR"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "15:00",
      "subject": "EM-IV",
      "teacher": "Dr. Revathy S.",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "15:00",
      "eTime": "16:00",
      "subject": "MP",
      "teacher": "Sejal",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "subject": "OS",
      "teacher": "Dipti",
      "location": "CR-4",
      "type": "TH"
    },
  ],
  "Tuesday": [
    {
      "sTime": "9:00",
      "eTime": "10:00",
      "subSlots": [
        {
          "activity": "Tuesday",
          // "activity": "EM-IV TUT",
          "group": "1",
          "teacher": "Dr. Revathy S.",
          "location": "CR-4",
        },
        {
          "activity": "Mentoring",
          "group": "2",
          "teacher": "Kalpita",
          "location": "SE-B",
        }
      ],
      "type": "TT"
    },
    {
      "sTime": "10:00",
      "eTime": "11:00",
      "subject": "DBMS",
      "teacher": "Sana A.",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "12:15",
      "subject": "MP",
      "teacher": "Sejal",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "12:15",
      "eTime": "13:15",
      "subject": "Python",
      "teacher": "Shainila",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "16:00",
      "subject": "Mini Project",
      "teacher": "Mayura",
      "location": "CC-1, CC-2",
      "type": "MP"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "activity": "Remedial",
      "location": "SE-B",
      "type": null
    },
  ],
  "Wednesday": [
    {
      "sTime": "9:00",
      "eTime": "11:00",
      "subSlots": [
        {
          "subject": "DBMS LAB",
          "batch": "A",
          "teacher": "Sana A.",
          "location": "CC-1",
        },
        {
          "subject": "OS Lab",
          "batch": "B",
          "teacher": "Dipti",
          "location": "CL-7",
        },
        {
          "subject": "Python LAB",
          "batch": "C",
          "teacher": "Shainila",
          "location": "CC-2",
        },
      ],
      "type": "PR"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "12:15",
      "subject": "OS",
      "teacher": "Dipti",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "12:15",
      "eTime": "13:15",
      "subject": "AOA",
      "teacher": "Dr. Amiya",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "16:00",
      "subSlots": [
        {
          "subject": "AOA LAB",
          "batch": "A",
          "teacher": "Dr. Amiya",
          "location": "CL-7",
        },
        {
          "subject": "Python LAB",
          "batch": "B",
          "teacher": "Shainila",
          "location": "CC-2",
        },
        {
          "subject": "MP LAB",
          "batch": "C",
          "teacher": "Sejal",
          "location": "CC-1",
        },
      ],
      "type": "PR"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "subSlots": [
        {
          "activity": "Mentoring",
          "group": "1",
          "teacher": "Kalpita",
          "location": "SE-B",
        },
        {
          "activity": "EM-IV TUT",
          "group": "2",
          "teacher": "Dr. Revathy S.",
          "location": "CR-4",
        },
      ],
      "type": "TT"
    }
  ],
  "Thursday": [
    {
      "sTime": "9:00",
      "eTime": "10:00",
      "subject": "DBMS",
      "teacher": "Sana A.",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "10:00",
      "eTime": "11:00",
      "subject": "EM-IV",
      "teacher": "Dr. Revathy S.",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "13:15",
      "subject": "Mini Project",
      "teacher": "Himani J",
      "location": "CC",
      "type": "MP"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "16:00",
      "subSlots": [
        {
          "subject": "Python LAB",
          "batch": "A",
          "teacher": "Shainila",
          "location": "CC-2",
        },
        {
          "subject": "MP LAB",
          "batch": "B",
          "teacher": "Sejal",
          "location": "CC-1",
        },
        {
          "subject": "DBMS LAB",
          "batch": "C",
          "teacher": "Sana A.",
          "location": "CL-3",
        }
      ],
      "type": "PR"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "activity": "Remedial",
      "location": "SE_COMP-B",
      "type": null
    },
  ],
  "Friday": [
    {
      "sTime": "9:00",
      "eTime": "10:00",
      "subject": "AOA",
      "teacher": "Dr. Amiya",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "10:00",
      "eTime": "11:00",
      "subject": "MP",
      "teacher": "Sejal",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "13:15",
      "subSlots": [
        {
          "subject": "OS Lab",
          "batch": "A",
          "teacher": "Dipti",
          "location": "CL-3",
        },
        {
          "subject": "DBMS LAB",
          "batch": "B",
          "teacher": "Varsha K",
          "location": "CC-2",
        },
        {
          "subject": "AOA LAB",
          "batch": "C",
          "teacher": "Dr. Amiya",
          "location": "CC-1",
        }
      ],
      "type": "PR"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "15:00",
      "subject": "DBMS",
      "teacher": "Sana A.",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "15:00",
      "eTime": "16:00",
      "subject": "OS",
      "teacher": "Dipti",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "subject": "EM-IV",
      "teacher": "Dr. Revathy S.",
      "location": "CR-4",
      "type": "TH"
    },
  ],
  "Saturday": [
    {
      "sTime": "9:00",
      "eTime": "11:00",
      "subSlots": [
        {
          "subject": "DBMS LAB",
          "batch": "A",
          "teacher": "Sana A.",
          "location": "CC-1",
        },
        {
          "subject": "OS Lab",
          "batch": "B",
          "teacher": "Dipti",
          "location": "CL-7",
        },
        {
          "subject": "Python LAB",
          "batch": "C",
          "teacher": "Shainila",
          "location": "CC-2",
        },
      ],
      "type": "PR"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "12:15",
      "subject": "OS",
      "teacher": "Dipti",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "12:15",
      "eTime": "13:15",
      "subject": "AOA",
      "teacher": "Dr. Amiya",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "16:00",
      "subSlots": [
        {
          "subject": "AOA LAB",
          "batch": "A",
          "teacher": "Dr. Amiya",
          "location": "CL-7",
        },
        {
          "subject": "Python LAB",
          "batch": "B",
          "teacher": "Shainila",
          "location": "CC-2",
        },
        {
          "subject": "MP LAB",
          "batch": "C",
          "teacher": "Sejal",
          "location": "CC-1",
        },
      ],
      "type": "PR"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "subSlots": [
        {
          "activity": "Mentoring",
          "group": "1",
          "teacher": "Kalpita",
          "location": "SE-B",
        },
        {
          "activity": "EM-IV TUT",
          "group": "2",
          "teacher": "Dr. Revathy S.",
          "location": "CR-4",
        },
      ],
      "type": "TT"
    }
  ],
  "Sunday": [
    {
      "sTime": "9:00",
      "eTime": "10:00",
      "subject": "AOA",
      "teacher": "Dr. Amiya",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "10:00",
      "eTime": "11:00",
      "subject": "MP",
      "teacher": "Sejal",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "13:15",
      "subSlots": [
        {
          "subject": "OS Lab",
          "batch": "A",
          "teacher": "Dipti",
          "location": "CL-3",
        },
        {
          "subject": "DBMS LAB",
          "batch": "B",
          "teacher": "Varsha K",
          "location": "CC-2",
        },
        {
          "subject": "AOA LAB",
          "batch": "C",
          "teacher": "Dr. Amiya",
          "location": "CC-1",
        }
      ],
      "type": "PR"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "15:00",
      "subject": "DBMS",
      "teacher": "Sana A.",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "15:00",
      "eTime": "16:00",
      "subject": "OS",
      "teacher": "Dipti",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "subject": "EM-IV",
      "teacher": "Dr. Revathy S.",
      "location": "CR-4",
      "type": "TH"
    },
  ],
};

var timeTable2 = {
  "Monday": [
    {
      "sTime": "9:00",
      "eTime": "10:00",
      "subject": "AOA",
      "teacher": "Dr. Amiya",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "10:00",
      "eTime": "11:00",
      "subject": "Python",
      "teacher": "Shainila",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "13:15",
      "subSlots": [
        {
          "subject": "MP LAB",
          "batch": "A",
          "teacher": "Sejal",
          "location": "CC-1",
        },
        {
          "subject": "AOA LAB",
          "batch": "B",
          "teacher": "Dr. Amiya",
          "location": "CC-2",
        },
        {
          "subject": "OS Lab",
          "batch": "C",
          "teacher": "Dipti",
          "location": "CL-3",
        }
      ],
      "type": "PR"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "15:00",
      "subject": "EM-IV",
      "teacher": "Dr. Revathy S.",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "15:00",
      "eTime": "16:00",
      "subject": "MP",
      "teacher": "Sejal",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "subject": "OS",
      "teacher": "Dipti",
      "location": "CR-4",
      "type": "TH"
    },
  ],
  "Tuesday": [
    {
      "sTime": "9:00",
      "eTime": "10:00",
      "subSlots": [
        {
          "activity": "EM-IV TUT",
          "group": "1",
          "teacher": "Dr. Revathy S.",
          "location": "CR-4",
        },
        {
          "activity": "Mentoring",
          "group": "2",
          "location": "SE-B",
        }
      ],
      "type": "TT"
    },
    {
      "sTime": "10:00",
      "eTime": "11:00",
      "subject": "DBMS",
      "teacher": "Sana A.",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "12:15",
      "subject": "MP",
      "teacher": "Sejal",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "12:15",
      "eTime": "13:15",
      "subject": "Python",
      "teacher": "Shainila",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "16:00",
      "subject": "Mini Project",
      "teacher": "Mayura",
      "location": "CC-1, CC-2",
      "type": "PR"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "activity": "Remedial",
      "location": "SE-B",
      "type": null
    },
  ],
  "Wednesday": [
    {
      "sTime": "9:00",
      "eTime": "11:00",
      "subSlots": [
        {
          "subject": "DBMS LAB",
          "batch": "A",
          "teacher": "Sana A.",
          "location": "CC-1",
        },
        {
          "subject": "OS Lab",
          "batch": "B",
          "teacher": "Dipti",
          "location": "CL-7",
        },
        {
          "subject": "Python LAB",
          "batch": "C",
          "teacher": "Shainila",
          "location": "CC-2",
        },
      ],
      "type": "PR"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "12:15",
      "subject": "OS",
      "teacher": "Dipti",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "12:15",
      "eTime": "13:15",
      "subject": "AOA",
      "teacher": "Dr. Amiya",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "16:00",
      "subSlots": [
        {
          "subject": "AOA LAB",
          "batch": "A",
          "teacher": "Dr. Amiya",
          "location": "CL-7",
        },
        {
          "subject": "Python LAB",
          "batch": "B",
          "teacher": "Shainila",
          "location": "CC-2",
        },
        {
          "subject": "MP LAB",
          "batch": "C",
          "teacher": "Sejal",
          "location": "CC-1",
        },
      ],
      "type": "PR"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "subSlots": [
        {
          "activity": "Mentoring",
          "group": "1",
          "location": "SE-B",
        },
        {
          "activity": "EM-IV TUT",
          "group": "2",
          "teacher": "Dr. Revathy S.",
          "location": "CR-4",
        },
      ],
      "type": "TT"
    }
  ],
  "Thursday": [
    {
      "sTime": "9:00",
      "eTime": "10:00",
      "subject": "DBMS",
      "teacher": "Sana A.",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "10:00",
      "eTime": "11:00",
      "subject": "EM-IV",
      "teacher": "Dr. Revathy S.",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "13:15",
      "subject": "Mini Project",
      "teacher": "Himani J",
      "location": "CC",
      "type": "PR"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "16:00",
      "subSlots": [
        {
          "subject": "Python LAB",
          "batch": "A",
          "teacher": "Shainila",
          "location": "CC-2",
        },
        {
          "subject": "MP LAB",
          "batch": "B",
          "teacher": "Sejal",
          "location": "CC-1",
        },
        {
          "subject": "DBMS LAB",
          "batch": "C",
          "teacher": "Sana A.",
          "location": "CL-3",
        }
      ],
      "type": "PR"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "activity": "Remedial",
      "location": "SE_COMP-B",
      "type": null
    },
  ],
  "Friday": [
    {
      "sTime": "9:00",
      "eTime": "10:00",
      "subject": "AOA",
      "teacher": "Dr. Amiya",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "10:00",
      "eTime": "11:00",
      "subject": "MP",
      "teacher": "Sejal",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "11:00",
      "eTime": "11:15",
      "activity": "Short Break",
      "type": null
    },
    {
      "sTime": "11:15",
      "eTime": "13:15",
      "subSlots": [
        {
          "subject": "OS Lab",
          "batch": "A",
          "teacher": "Dipti",
          "location": "CL-3",
        },
        {
          "subject": "DBMS LAB",
          "batch": "B",
          "teacher": "Varsha K",
          "location": "CC-2",
        },
        {
          "subject": "AOA LAB",
          "batch": "C",
          "teacher": "Dr. Amiya",
          "location": "CC-1",
        }
      ],
      "type": "PR"
    },
    {
      "sTime": "13:15",
      "eTime": "14:00",
      "activity": "Lunch Break",
      "type": null
    },
    {
      "sTime": "14:00",
      "eTime": "15:00",
      "subject": "DBMS",
      "teacher": "Sana A.",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "15:00",
      "eTime": "16:00",
      "subject": "OS",
      "teacher": "Dipti",
      "location": "CR-4",
      "type": "TH"
    },
    {
      "sTime": "16:00",
      "eTime": "17:00",
      "subject": "EM-IV",
      "teacher": "Dr. Revathy S.",
      "location": "CR-4",
      "type": "TH"
    },
  ]
};

var timeTableJson =
    '{"Monday":[{"sTime":"9:00","eTime":"10:00","subject":"AOA","teacher":"Dr. Amiya","location":"CR-4","activity":null,"type":"TH","subSlots":null}]}';
