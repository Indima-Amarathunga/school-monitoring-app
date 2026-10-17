sv import from ..services.schoolService { SchoolEvent, get_school_dashboard, add_school_event }
import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.button { Button }
import from "@jac/runtime" { Link, useNavigate }
import from "@hugeicons/react" { HugeiconsIcon }
import from "@hugeicons/core-free-icons" { Home01Icon, Calendar01Icon, BookOpen01Icon, Message01Icon, UserGroupIcon, CheckmarkCircle02Icon, Notification01Icon, Add01Icon, Clock01Icon, ChartHistogramIcon }


def:pub SchoolDashboard() -> JsxElement {
    has events: list[SchoolEvent] = [];
    has loading: bool = True;
    has load_error: bool = False;
    has role: str = "Parent";
    has event_title: str = "";
    has event_date: str = "";
    has event_details: str = "";
    has event_message: str = "";
    has adding_event: bool = False;
    nav = useNavigate();

    async can with entry {
        saved_role = sessionStorage.getItem("schoolhouse_demo_role");
        if saved_role { role = saved_role; }
        try {
            dashboard = await get_school_dashboard();
            events = dashboard["events"] as list[SchoolEvent];
            loading = False;
        } except Exception {
            load_error = True;
            loading = False;
        }
    }

    def handle_title(e: ChangeEvent) { event_title = e.target.value; }
    def handle_date(e: ChangeEvent) { event_date = e.target.value; }
    def handle_details(e: ChangeEvent) { event_details = e.target.value; }

    async def create_event() {
        if not event_title.strip() or not event_date.strip() { event_message = "Add an event title and date first."; return; }
        adding_event = True;
        result = await add_school_event(event_title, event_date, event_details, "teacher-demo");
        if result != None {
            events = events + [result];
            event_title = "";
            event_date = "";
            event_details = "";
            event_message = "Event added to the school calendar.";
        } else {
            event_message = "Only a verified teacher profile can add events.";
        }
        adding_event = False;
    }

    menu_item = "flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-muted-foreground transition-colors hover:bg-muted hover:text-foreground";
    active_item = "flex items-center gap-3 rounded-lg bg-primary/10 px-3 py-2.5 text-sm font-medium text-primary";

    return <div className="min-h-screen bg-muted/40 text-foreground">
        <div className="mx-auto flex min-h-screen max-w-[1440px]">
            <aside className="hidden w-64 shrink-0 flex-col border-r bg-card px-5 py-6 md:flex">
                <div className="mb-9 flex items-center gap-3 px-1">
                    <div className="flex size-10 items-center justify-center rounded-xl bg-primary text-primary-foreground"><HugeiconsIcon icon={Home01Icon} strokeWidth={2} className="size-5" /></div>
                    <div><p className="font-semibold tracking-tight">Schoolhouse</p><p className="text-xs text-muted-foreground">Family portal</p></div>
                </div>
                <p className="mb-2 px-3 text-xs font-medium uppercase tracking-wider text-muted-foreground">Workspace</p>
                <nav className="flex flex-col gap-1">
                    <Link to="/" className={active_item}><HugeiconsIcon icon={ChartHistogramIcon} strokeWidth={2} className="size-4" />Overview</Link>
                    {role == "Teacher" and <Link to="/students" className={menu_item}><HugeiconsIcon icon={UserGroupIcon} strokeWidth={2} className="size-4" />Students</Link>}
                    <Link to="/progress" className={menu_item}><HugeiconsIcon icon={BookOpen01Icon} strokeWidth={2} className="size-4" />Learning progress</Link>
                    <Link to="/homework" className={menu_item}><HugeiconsIcon icon={CheckmarkCircle02Icon} strokeWidth={2} className="size-4" />Homework</Link>
                    <Link to="/calendar" className={menu_item}><HugeiconsIcon icon={Calendar01Icon} strokeWidth={2} className="size-4" />Calendar</Link>
                    <Link to="/notices" className={menu_item}><HugeiconsIcon icon={Notification01Icon} strokeWidth={2} className="size-4" />Notices</Link>
                    <Link to="/messages" className={menu_item}><HugeiconsIcon icon={Message01Icon} strokeWidth={2} className="size-4" />Messages</Link>
                    <Link to="/profiles" className={menu_item}><HugeiconsIcon icon={UserGroupIcon} strokeWidth={2} className="size-4" />Profiles</Link>
                    <Link to="/materials" className={menu_item}><HugeiconsIcon icon={BookOpen01Icon} strokeWidth={2} className="size-4" />Learning materials</Link>
                    <Link to="/event-media" className={menu_item}><HugeiconsIcon icon={Calendar01Icon} strokeWidth={2} className="size-4" />Event media</Link>
                </nav>
                <div className="mt-auto rounded-xl bg-muted/70 p-4">
                    <p className="text-sm font-medium">Need a hand?</p>
                    <p className="mt-1 text-xs leading-relaxed text-muted-foreground">Your class teacher is here to help your child thrive.</p>
                    <a href="#community" className="mt-3 inline-block text-xs font-medium text-primary">Message the teacher</a>
                </div>
            </aside>
            <main id="overview" className="min-w-0 flex-1 px-4 py-5 sm:px-6 lg:px-9 lg:py-8">
                <header className="mb-8 flex flex-wrap items-center justify-between gap-4">
                    <div className="flex items-center gap-3 md:hidden"><div className="flex size-9 items-center justify-center rounded-lg bg-primary text-primary-foreground"><HugeiconsIcon icon={Home01Icon} strokeWidth={2} className="size-4" /></div><span className="font-semibold">Schoolhouse</span></div>
                    <div className="hidden md:block"><p className="text-sm text-muted-foreground">Monday, 17 October</p><p className="font-medium">Oakwood Primary · Academic year 2024–25</p></div>
                    <div className="ml-auto flex items-center gap-3">
                        <label className="sr-only" htmlFor="role">Viewing as</label>
                        <div className="flex flex-col gap-0.5"><label className="text-[10px] text-muted-foreground" htmlFor="role">Preview role (demo only)</label><select id="role" value={role} onChange={lambda (e: ChangeEvent) { role = e.target.value; sessionStorage.setItem("schoolhouse_demo_role", e.target.value); nav("/"); }} className="h-9 rounded-lg border border-border bg-card px-3 text-sm"><option value="Parent">Parent</option><option value="Teacher">Teacher</option></select></div>
                        <button className="relative flex size-9 items-center justify-center rounded-full border bg-card text-muted-foreground" aria-label="Notifications"><HugeiconsIcon icon={Notification01Icon} strokeWidth={2} className="size-4" /><span className="absolute right-2 top-2 size-1.5 rounded-full bg-primary" /></button>
                        <div className="flex items-center gap-2 rounded-full border bg-card py-1 pl-1 pr-3"><div className="flex size-9 items-center justify-center rounded-full bg-amber-100 text-xs font-semibold text-amber-900">{role == "Parent" and "MP" or "LC"}</div><div className="hidden sm:block"><p className="text-xs font-medium leading-tight">{role == "Parent" and "Maya Patel" or "Ms. Lin Chen"}</p><p className="text-[10px] leading-tight text-muted-foreground">{role == "Parent" and "Child account" or "Teacher account"}</p></div></div>
                    </div>
                </header>
                <div className="mb-7 flex flex-wrap items-end justify-between gap-4">
                    <div><p className="mb-1 text-sm font-medium text-primary">Your family dashboard</p><h1 className="text-2xl font-semibold tracking-tight sm:text-3xl">Good morning, Alex</h1><p className="mt-1 text-sm text-muted-foreground">A little look at Maya’s week at school.</p></div>
                    {role == "Teacher" and <Button onClick={lambda { event_message = "Enter event details below to add it to the calendar."; }} className="shadow-sm"><HugeiconsIcon icon={Add01Icon} strokeWidth={2} className="size-4" />Add school event</Button>}
                </div>
                <section className="mb-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
                    <Card className="shadow-sm"><CardContent className="flex items-center gap-4"><div className="flex size-11 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary"><HugeiconsIcon icon={CheckmarkCircle02Icon} strokeWidth={2} className="size-5" /></div><div><p className="text-sm text-muted-foreground">Homework this week</p><p className="text-2xl font-semibold tabular-nums">8 <span className="text-sm font-normal text-muted-foreground">of 10 done</span></p></div></CardContent></Card>
                    <Card className="shadow-sm"><CardContent className="flex items-center gap-4"><div className="flex size-11 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary"><HugeiconsIcon icon={UserGroupIcon} strokeWidth={2} className="size-5" /></div><div><p className="text-sm text-muted-foreground">Class participation</p><p className="text-2xl font-semibold">Good</p></div></CardContent></Card>
                    <Card className="shadow-sm"><CardContent className="flex items-center gap-4"><div className="flex size-11 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary"><HugeiconsIcon icon={Calendar01Icon} strokeWidth={2} className="size-5" /></div><div><p className="text-sm text-muted-foreground">Attendance this week</p><p className="text-2xl font-semibold tabular-nums">5 <span className="text-sm font-normal text-muted-foreground">of 5 days</span></p></div></CardContent></Card>
                    <Card className="shadow-sm"><CardContent className="flex items-center gap-4"><div className="flex size-11 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary"><HugeiconsIcon icon={BookOpen01Icon} strokeWidth={2} className="size-5" /></div><div><p className="text-sm text-muted-foreground">Areas to practise</p><p className="text-2xl font-semibold">2 <span className="text-sm font-normal text-muted-foreground">topics</span></p></div></CardContent></Card>
                </section>
                <section className="mb-6 grid gap-4 lg:grid-cols-5">
                    <Card id="progress" className="shadow-sm lg:col-span-3"><CardHeader><CardTitle>Learning progress</CardTitle><CardDescription>Maya Patel · Grade 3, Room 12 · Ms. Chen</CardDescription></CardHeader><CardContent className="flex flex-col gap-5">
                        <div><div className="mb-2 flex justify-between text-sm"><span className="font-medium">Mathematics</span><span className="text-muted-foreground">Building confidence</span></div><div className="h-2 overflow-hidden rounded-full bg-muted"><div className="h-full w-[72%] rounded-full bg-amber-400" /></div><p className="mt-2 text-xs text-muted-foreground">Addition is a strength. Practise subtraction with borrowing.</p></div>
                        <div><div className="mb-2 flex justify-between text-sm"><span className="font-medium">Language</span><span className="text-muted-foreground">On track</span></div><div className="h-2 overflow-hidden rounded-full bg-muted"><div className="h-full w-[84%] rounded-full bg-sky-400" /></div><p className="mt-2 text-xs text-muted-foreground">Enjoys reading aloud; working on spelling patterns.</p></div>
                        <div><div className="mb-2 flex justify-between text-sm"><span className="font-medium">Science</span><span className="text-muted-foreground">Growing well</span></div><div className="h-2 overflow-hidden rounded-full bg-muted"><div className="h-full w-[66%] rounded-full bg-emerald-400" /></div><p className="mt-2 text-xs text-muted-foreground">Curious in class discussions and hands-on activities.</p></div>
                    </CardContent></Card>
                    <Card id="homework" className="shadow-sm lg:col-span-2"><CardHeader><CardTitle>Homework to finish</CardTitle><CardDescription>Two activities coming up</CardDescription></CardHeader><CardContent className="flex flex-col gap-4">
                        <div className="flex items-start gap-3 rounded-lg border p-3"><div className="mt-0.5 flex size-8 items-center justify-center rounded-lg bg-primary/10 text-primary"><HugeiconsIcon icon={BookOpen01Icon} strokeWidth={2} className="size-4" /></div><div className="min-w-0 flex-1"><p className="text-sm font-medium">Subtraction practice</p><p className="text-xs text-muted-foreground">Mathematics · Exercises 1–10</p><p className="mt-2 flex items-center gap-1 text-xs text-primary"><HugeiconsIcon icon={Clock01Icon} strokeWidth={2} className="size-3.5" />Due Wednesday, 19 Oct</p></div><span className="rounded-full bg-amber-100 px-2 py-1 text-[10px] font-medium text-amber-900">Pending</span></div>
                        <div className="flex items-start gap-3 rounded-lg border p-3"><div className="mt-0.5 flex size-8 items-center justify-center rounded-lg bg-primary/10 text-primary"><HugeiconsIcon icon={BookOpen01Icon} strokeWidth={2} className="size-4" /></div><div className="min-w-0 flex-1"><p className="text-sm font-medium">Read chapter four</p><p className="text-xs text-muted-foreground">Language · The Garden Path</p><p className="mt-2 flex items-center gap-1 text-xs text-muted-foreground"><HugeiconsIcon icon={Clock01Icon} strokeWidth={2} className="size-3.5" />Due Friday, 21 Oct</p></div><span className="rounded-full bg-muted px-2 py-1 text-[10px] font-medium text-muted-foreground">Started</span></div>
                    </CardContent></Card>
                </section>
                <section className="grid gap-4 lg:grid-cols-5">
                    <Card id="calendar" className="shadow-sm lg:col-span-3"><CardHeader className="flex flex-row items-start justify-between gap-4"><div><CardTitle>Coming up</CardTitle><CardDescription>School events and important dates</CardDescription></div><HugeiconsIcon icon={Calendar01Icon} strokeWidth={2} className="size-5 text-primary" /></CardHeader><CardContent className="flex flex-col gap-3">
                        {loading and <p className="py-4 text-sm text-muted-foreground">Loading school calendar…</p>}
                        {load_error and <p className="py-4 text-sm text-destructive">Could not load the school calendar. Refresh to try again.</p>}
                        {not loading and not load_error and len(events) == 0 and <div className="rounded-lg border border-dashed px-4 py-8 text-center"><p className="font-medium">No events scheduled yet</p><p className="mt-1 text-sm text-muted-foreground">School events and birthdays will appear here.</p></div>}
                        {for event in events {<div key={jid(event)} className="flex items-center gap-3 rounded-lg border p-3"><div className="min-w-12 rounded-lg bg-primary/10 px-2 py-2 text-center text-xs font-semibold text-primary">{event.event_date}</div><div className="min-w-0"><p className="text-sm font-medium">{event.title}</p><p className="text-xs text-muted-foreground">{event.details}</p></div></div>}}
                        {role == "Teacher" and <div className="mt-2 rounded-xl border bg-muted/30 p-4"><p className="mb-3 text-sm font-semibold">Add a school event</p><div className="grid gap-3 sm:grid-cols-2"><label className="flex flex-col gap-1 text-xs font-medium">Event title<input value={event_title} onChange={handle_title} placeholder="Class assembly" className="h-9 rounded-md border bg-card px-3 text-sm font-normal" /></label><label className="flex flex-col gap-1 text-xs font-medium">Date<input type="date" value={event_date} onChange={handle_date} className="h-9 rounded-md border bg-card px-3 text-sm font-normal" /></label></div><label className="mt-3 flex flex-col gap-1 text-xs font-medium">Details<input value={event_details} onChange={handle_details} placeholder="A short note for families" className="h-9 rounded-md border bg-card px-3 text-sm font-normal" /></label><div className="mt-3 flex flex-wrap items-center gap-3"><Button size="sm" disabled={adding_event} onClick={create_event}>{adding_event and "Adding…" or "Add event"}</Button><span className="text-xs text-muted-foreground">Teacher access only</span></div>{event_message and <p className="mt-2 text-xs text-muted-foreground">{event_message}</p>}</div>}
                    </CardContent></Card>
                    <div className="flex flex-col gap-4 lg:col-span-2">
                        <Card id="notices" className="shadow-sm"><CardHeader><CardTitle>Classroom note</CardTitle><CardDescription>From Ms. Chen · Today</CardDescription></CardHeader><CardContent><p className="text-sm leading-relaxed">Maya shared thoughtful ideas during our science activity today. At home, try asking what she noticed about how seeds grow.</p><a id="community" href="mailto:teacher@oakwood.example" className="mt-4 inline-flex items-center gap-2 text-sm font-medium text-primary"><HugeiconsIcon icon={Message01Icon} strokeWidth={2} className="size-4" />Message Ms. Chen</a></CardContent></Card>
                        <Card className="shadow-sm"><CardHeader><CardTitle>This week’s goal</CardTitle><CardDescription>A little practice makes a big difference</CardDescription></CardHeader><CardContent><div className="flex items-start gap-3"><div className="flex size-9 shrink-0 items-center justify-center rounded-lg bg-primary/10 text-primary"><HugeiconsIcon icon={CheckmarkCircle02Icon} strokeWidth={2} className="size-4" /></div><div><p className="text-sm font-medium">Read together for 10 minutes</p><p className="mt-1 text-xs text-muted-foreground">Parent and Maya · Review Friday</p></div></div></CardContent></Card>
                    </div>
                </section>
                <footer className="mt-7 border-t pt-4 text-xs text-muted-foreground">Family and teacher records are private to authorised school users.</footer>
            </main>
        </div>
    </div>;
}
