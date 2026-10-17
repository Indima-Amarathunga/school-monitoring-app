import from services.schoolService { SchoolEvent, get_school_dashboard, add_school_event, update_teacher_profile, update_child_profile }
import from .components.SchoolDashboard { SchoolDashboard }
import from .components.LearningProgress { LearningProgress }
import from .components.Homework { Homework }
import from .components.SchoolCalendar { SchoolCalendar }
import from .components.SchoolNotices { SchoolNotices }
import from .components.SchoolMessages { SchoolMessages }
import from .components.SchoolProfiles { SchoolProfiles }
import from .components.LearningMaterials { LearningMaterials }
import from .components.EventMedia { EventMedia }
import from components.StudentRoster { StudentRoster }
import from "@jac/runtime" { Router, Routes, Route }
import ".styles.global.css";

def:pub app() -> JsxElement {
    return <Router><Routes>
        <Route path="/" element={<SchoolDashboard />} />
        <Route path="/students" element={<StudentRoster />} />
        <Route path="/progress" element={<LearningProgress />} />
        <Route path="/homework" element={<Homework />} />
        <Route path="/calendar" element={<SchoolCalendar />} />
        <Route path="/notices" element={<SchoolNotices />} />
        <Route path="/messages" element={<SchoolMessages />} />
        <Route path="/profiles" element={<SchoolProfiles />} />
        <Route path="/materials" element={<LearningMaterials />} />
        <Route path="/event-media" element={<EventMedia />} />
    </Routes></Router>;
}
