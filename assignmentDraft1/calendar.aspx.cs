using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class calendar : System.Web.UI.Page
    {
        private int userId;
        private DateTime currentMonth;
        private DateTime selectedDate;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Load user info on every page load
            LoadUserInfo();

            if (!IsPostBack)
            {
                // Set default dates
                if (Request.QueryString["date"] != null)
                {
                    if (DateTime.TryParse(Request.QueryString["date"], out DateTime queryDate))
                    {
                        currentMonth = new DateTime(queryDate.Year, queryDate.Month, 1);
                        selectedDate = queryDate;
                    }
                    else
                    {
                        currentMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                        selectedDate = DateTime.Now;
                    }
                }
                else
                {
                    currentMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                    selectedDate = DateTime.Now;
                }

                // Load calendar data
                GenerateCalendar();
                LoadDayEvents();
            }
        }

        private void LoadUserInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT UserID, Name, Role FROM Users WHERE Username = @Email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    userId = Convert.ToInt32(reader["UserID"]);
                    lblName.Text = reader["Name"].ToString();
                    lblRole.Text = reader["Role"].ToString();
                    lblSidebarName.Text = reader["Name"].ToString();
                    lblSidebarRole.Text = reader["Role"].ToString();
                }
                else
                {
                    Response.Redirect("loginWebform.aspx");
                }
            }
        }

        private void GenerateCalendar()
        {
            // Get events for the current month
            Dictionary<DateTime, List<AssignmentEvent>> monthEvents = GetMonthEvents();

            // Get the first day of the month
            DateTime firstDayOfMonth = new DateTime(currentMonth.Year, currentMonth.Month, 1);

            // Get the day of week for the first day (0 = Sunday, 6 = Saturday)
            int firstDayOfWeek = (int)firstDayOfMonth.DayOfWeek;

            // Get the last day of the month
            DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            // Get the day of week for the last day
            int lastDayOfWeek = (int)lastDayOfMonth.DayOfWeek;

            // Calculate the number of days from the previous month to show
            int daysFromPrevMonth = firstDayOfWeek;

            // Calculate the number of days from the next month to show
            int daysFromNextMonth = 6 - lastDayOfWeek;

            // Start date for the calendar (may be from previous month)
            DateTime calendarStartDate = firstDayOfMonth.AddDays(-daysFromPrevMonth);

            // End date for the calendar (may be from next month)
            DateTime calendarEndDate = lastDayOfMonth.AddDays(daysFromNextMonth);

            // Build the calendar HTML
            StringBuilder calendarHtml = new StringBuilder();

            // Current date for comparison
            DateTime currentDate = DateTime.Now.Date;

            // Loop through each day in the calendar range
            for (DateTime date = calendarStartDate; date <= calendarEndDate; date = date.AddDays(1))
            {
                // Determine CSS classes for the day
                string cssClass = "calendar-day";

                // Check if the day is from the current month
                if (date.Month != currentMonth.Month)
                {
                    cssClass += " other-month";
                }

                // Check if the day is today
                if (date.Date.Equals(currentDate))
                {
                    cssClass += " today";
                }

                // Check if this is the selected date
                if (date.Date.Equals(selectedDate.Date))
                {
                    cssClass += " selected";
                }

                // Start the day container
                calendarHtml.AppendFormat("<div class=\"{0}\" data-date=\"{1}\">",
                    cssClass, date.ToString("yyyy-MM-dd"));

                // Add the day number
                calendarHtml.AppendFormat("<div class=\"day-number\">{0}</div>", date.Day);

                // Add events for this day
                if (monthEvents.ContainsKey(date.Date))
                {
                    calendarHtml.Append("<div class=\"event-list\">");

                    // Get events for this day
                    List<AssignmentEvent> dayEvents = monthEvents[date.Date];

                    // Sort events by time
                    dayEvents.Sort((a, b) => a.DueTime.CompareTo(b.DueTime));

                    // Show up to 3 events, then show "more" indicator
                    int eventsToShow = Math.Min(dayEvents.Count, 3);

                    for (int i = 0; i < eventsToShow; i++)
                    {
                        AssignmentEvent evt = dayEvents[i];
                        string eventClass = evt.IsOverdue ? "event-overdue" : "event-assignment";

                        calendarHtml.AppendFormat(
                            "<div class=\"event-item {0}\" data-event-id=\"{1}\">" +
                            "<span class=\"event-dot\"></span>{2}</div>",
                            eventClass, evt.AssignmentId, evt.Title);
                    }

                    // If there are more events, show a "more" indicator
                    if (dayEvents.Count > 3)
                    {
                        calendarHtml.AppendFormat("<div class=\"more-events\">+{0} more</div>",
                            dayEvents.Count - 3);
                    }

                    calendarHtml.Append("</div>");
                }

                // Close the day container
                calendarHtml.Append("</div>");
            }

            // Set the calendar HTML
            litCalendarDays.Text = calendarHtml.ToString();
        }

        private void LoadDayEvents()
        {
            // Get events for the selected day
            List<AssignmentEvent> dayEvents = GetDayEvents(selectedDate);

            StringBuilder eventsHtml = new StringBuilder();

            if (dayEvents.Count > 0)
            {
                // Sort events by time
                dayEvents.Sort((a, b) => a.DueTime.CompareTo(b.DueTime));

                foreach (AssignmentEvent evt in dayEvents)
                {
                    string timeDisplay = evt.DueTime.ToString("h:mm tt");
                    string eventClass = evt.IsOverdue ? "timeline-overdue" : "timeline-assignment";

                    eventsHtml.AppendFormat(
                        "<div class=\"timeline-item {0}\" data-event-id=\"{1}\" data-event-type=\"{2}\">" +
                        "<div class=\"time\">{3}</div>" +
                        "<div class=\"title\">{4}</div>" +
                        "<div class=\"description\">{5}</div>",
                        eventClass, evt.AssignmentId, evt.IsOverdue ? "overdue" : "pending",
                        timeDisplay, evt.Title, evt.Description);

                    // Add action button
                    eventsHtml.Append("<div class=\"event-actions\">");
                    eventsHtml.AppendFormat(
                        "<a href=\"assignment-details.aspx?assignmentID={0}\" class=\"inline-btn\">" +
                        "<i class=\"fas fa-eye\"></i> View Assignment</a>",
                        evt.AssignmentId);
                    eventsHtml.Append("</div>"); // Close event-actions

                    eventsHtml.Append("</div>"); // Close timeline-item
                }
            }
            else
            {
                // No events for this day
                eventsHtml.Append(
                    "<div class=\"no-events\">" +
                    "<i class=\"fas fa-calendar-times\"></i>" +
                    "<p>No assignments due on this day</p>" +
                    "</div>");
            }

            litDayEvents.Text = eventsHtml.ToString();
        }

        private Dictionary<DateTime, List<AssignmentEvent>> GetMonthEvents()
        {
            Dictionary<DateTime, List<AssignmentEvent>> monthEvents = new Dictionary<DateTime, List<AssignmentEvent>>();

            // Get the first and last day to display in the calendar
            DateTime firstDayOfMonth = new DateTime(currentMonth.Year, currentMonth.Month, 1);
            int daysFromPrevMonth = (int)firstDayOfMonth.DayOfWeek;
            DateTime calendarStartDate = firstDayOfMonth.AddDays(-daysFromPrevMonth);

            DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);
            int daysFromNextMonth = 6 - (int)lastDayOfMonth.DayOfWeek;
            DateTime calendarEndDate = lastDayOfMonth.AddDays(daysFromNextMonth);

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Query to get assignments for courses the student is enrolled in
                // Only includes pending assignments (no submission) and overdue assignments
                string query = @"
                    SELECT 
                        a.AssignmentID,
                        a.Title,
                        a.Description,
                        a.DueDate,
                        a.MaxPoints,
                        c.CourseName,
                        c.CourseID,
                        m.Title AS ModuleTitle,
                        CASE WHEN a.DueDate < GETDATE() THEN 1 ELSE 0 END AS IsOverdue
                    FROM Assignments a
                    JOIN Modules m ON a.ModuleID = m.ModuleID
                    JOIN Courses c ON m.CourseID = c.CourseID
                    JOIN UserCourses uc ON c.CourseID = uc.CourseID
                    LEFT JOIN AssignmentSubmissions s ON a.AssignmentID = s.AssignmentID AND s.UserID = @UserID
                    WHERE 
                        uc.UserID = @UserID
                        AND a.IsActive = 1
                        AND s.SubmissionID IS NULL -- No submission yet
                        AND a.DueDate BETWEEN @StartDate AND @EndDate
                    ORDER BY a.DueDate ASC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@StartDate", calendarStartDate);
                cmd.Parameters.AddWithValue("@EndDate", calendarEndDate);

                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    DateTime dueDate = Convert.ToDateTime(reader["DueDate"]);

                    // Create an assignment event
                    AssignmentEvent assignmentEvent = new AssignmentEvent
                    {
                        AssignmentId = Convert.ToInt32(reader["AssignmentID"]),
                        Title = reader["Title"].ToString(),
                        Description = reader["Description"].ToString(),
                        DueDate = dueDate.Date,
                        DueTime = dueDate,
                        MaxPoints = Convert.ToInt32(reader["MaxPoints"]),
                        CourseName = reader["CourseName"].ToString(),
                        CourseId = Convert.ToInt32(reader["CourseID"]),
                        ModuleTitle = reader["ModuleTitle"].ToString(),
                        IsOverdue = Convert.ToBoolean(reader["IsOverdue"])
                    };

                    // Add to the dictionary
                    if (!monthEvents.ContainsKey(dueDate.Date))
                    {
                        monthEvents[dueDate.Date] = new List<AssignmentEvent>();
                    }

                    monthEvents[dueDate.Date].Add(assignmentEvent);
                }
            }

            return monthEvents;
        }

        private List<AssignmentEvent> GetDayEvents(DateTime date)
        {
            List<AssignmentEvent> dayEvents = new List<AssignmentEvent>();

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Query to get assignments due on the selected day
                string query = @"
                    SELECT 
                        a.AssignmentID,
                        a.Title,
                        a.Description,
                        a.DueDate,
                        a.MaxPoints,
                        c.CourseName,
                        c.CourseID,
                        m.Title AS ModuleTitle,
                        CASE WHEN a.DueDate < GETDATE() THEN 1 ELSE 0 END AS IsOverdue
                    FROM Assignments a
                    JOIN Modules m ON a.ModuleID = m.ModuleID
                    JOIN Courses c ON m.CourseID = c.CourseID
                    JOIN UserCourses uc ON c.CourseID = uc.CourseID
                    LEFT JOIN AssignmentSubmissions s ON a.AssignmentID = s.AssignmentID AND s.UserID = @UserID
                    WHERE 
                        uc.UserID = @UserID
                        AND a.IsActive = 1
                        AND s.SubmissionID IS NULL -- No submission yet
                        AND CONVERT(date, a.DueDate) = @DueDate
                    ORDER BY a.DueDate ASC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@DueDate", date.Date);

                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    DateTime dueDate = Convert.ToDateTime(reader["DueDate"]);

                    // Create an assignment event
                    AssignmentEvent assignmentEvent = new AssignmentEvent
                    {
                        AssignmentId = Convert.ToInt32(reader["AssignmentID"]),
                        Title = reader["Title"].ToString(),
                        Description = reader["Description"].ToString(),
                        DueDate = dueDate.Date,
                        DueTime = dueDate,
                        MaxPoints = Convert.ToInt32(reader["MaxPoints"]),
                        CourseName = reader["CourseName"].ToString(),
                        CourseId = Convert.ToInt32(reader["CourseID"]),
                        ModuleTitle = reader["ModuleTitle"].ToString(),
                        IsOverdue = Convert.ToBoolean(reader["IsOverdue"])
                    };

                    dayEvents.Add(assignmentEvent);
                }
            }

            return dayEvents;
        }

        protected void btnToday_Click(object sender, EventArgs e)
        {
            // Reset to today's date
            currentMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            selectedDate = DateTime.Now;

            // Reload the calendar
            GenerateCalendar();
            LoadDayEvents();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect("searchResults.aspx?query=" + Server.UrlEncode(query));
            }
        }
    }

    // Helper class to represent assignment events
    public class AssignmentEvent
    {
        public int AssignmentId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime DueDate { get; set; }
        public DateTime DueTime { get; set; }
        public int MaxPoints { get; set; }
        public string CourseName { get; set; }
        public int CourseId { get; set; }
        public string ModuleTitle { get; set; }
        public bool IsOverdue { get; set; }
    }
}