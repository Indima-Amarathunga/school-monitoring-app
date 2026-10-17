import from services.schoolService { SchoolEvent, get_school_dashboard, add_school_event, update_teacher_profile, update_child_profile }
import from .components.SchoolDashboard { SchoolDashboard }
import ".styles.global.css";

def:pub app() -> JsxElement {
    return <SchoolDashboard />;
}
