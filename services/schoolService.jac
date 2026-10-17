node TeacherProfile {
    has name: str = "";
    has photo_url: str = "";
    has contact_number: str = "";
    has address: str = "";
    has birthday: str = "";
}

node ChildProfile {
    has full_name: str = "";
    has photo_url: str = "";
    has birthday: str = "";
    has address: str = "";
    has grade_class: str = "";
    has register_number: str = "";
    has parent_names: str = "";
    has parent_contacts: str = "";
    has medical_conditions: str = "";
}

node SchoolEvent {
    has title: str = "";
    has event_date: str = "";
    has details: str = "";
    has event_type: str = "school";
    has created_by: str = "";
}

node LearningMaterial {
    has title: str = "";
    has subject: str = "";
    has resource_url: str = "";
    has media_kind: str = "document";
}

node EventMedia {
    has title: str = "";
    has media_url: str = "";
    has media_kind: str = "photo";
    has event_date: str = "";
}

node SubjectProgress {
    has subject: str = "";
    has level: str = "";
    has strengths: str = "";
    has practice: str = "";
}

node Homework {
    has subject: str = "";
    has title: str = "";
    has due_date: str = "";
    has status: str = "Pending";
}

node AttendanceRecord {
    has record_date: str = "";
    has status: str = "Present";
}

node SchoolNotice {
    has title: str = "";
    has notice_date: str = "";
    has acknowledged: bool = False;
}

node LearningGoal {
    has title: str = "";
    has helper: str = "";
    has review: str = "";
}

edge Teaches: TeacherProfile --> ChildProfile {}
edge ParentOf: ChildProfile --> ChildProfile { has parent_name: str = ""; }


def:pub get_school_dashboard() -> dict {
    children = [root -->][?:ChildProfile];
    teachers = [root -->][?:TeacherProfile];
    events = [root -->][?:SchoolEvent];
    materials = [root -->][?:LearningMaterial];
    media = [root -->][?:EventMedia];
    return {
        "children": children,
        "teachers": teachers,
        "events": events,
        "materials": materials,
        "media": media
    };
}


def:pub add_school_event(title: str, event_date: str, details: str, actor_teacher_id: str) -> SchoolEvent | None {
    if not title.strip() or not event_date.strip() { return None; }
    teacher_found = False;
    for teacher in [root -->][?:TeacherProfile] {
        if jid(teacher) == actor_teacher_id { teacher_found = True; }
    }
    if not teacher_found { return None; }
    return root ++> SchoolEvent(title=title.strip(), event_date=event_date, details=details, created_by=actor_teacher_id);
}


def:pub update_teacher_profile(profile_id: str, name: str, contact_number: str, address: str, birthday: str, photo_url: str) -> TeacherProfile | None {
    for teacher in [root -->][?:TeacherProfile] {
        if jid(teacher) == profile_id {
            teacher.name = name;
            teacher.contact_number = contact_number;
            teacher.address = address;
            teacher.birthday = birthday;
            teacher.photo_url = photo_url;
            return teacher;
        }
    }
    return None;
}


def:pub update_child_profile(profile_id: str, full_name: str, birthday: str, address: str, grade_class: str, register_number: str, parent_names: str, parent_contacts: str, medical_conditions: str, photo_url: str) -> ChildProfile | None {
    for child in [root -->][?:ChildProfile] {
        if jid(child) == profile_id {
            child.full_name = full_name;
            child.birthday = birthday;
            child.address = address;
            child.grade_class = grade_class;
            child.register_number = register_number;
            child.parent_names = parent_names;
            child.parent_contacts = parent_contacts;
            child.medical_conditions = medical_conditions;
            child.photo_url = photo_url;
            return child;
        }
    }
    return None;
}
