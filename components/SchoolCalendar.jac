sv import from ..services.schoolService { SchoolEvent, get_calendar_events, create_calendar_event }
import from "@jac/runtime" { Link }
import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.button { Button }
import from "@hugeicons/react" { HugeiconsIcon }
import from "@hugeicons/core-free-icons" { Home01Icon, Add01Icon, ArrowLeft01Icon, ArrowRight01Icon }

def:pub SchoolCalendar() -> JsxElement {
    has events: list[SchoolEvent] = [];
    has role: str = "Parent";
    has title: str = "";
    has event_date: str = "";
    has details: str = "";
    has message: str = "";
    has loading: bool = True;
    has year: int = 2026;
    has month_index: int = 9;
    has selected_day: int = 0;

    async can with entry {
        saved_role = sessionStorage.getItem("schoolhouse_demo_role");
        if saved_role { role = saved_role; }
        try {
            events = await get_calendar_events();
        } except Exception {
            message = "Calendar events could not be loaded.";
        }
        loading = False;
    }

    def previous_month {
        if month_index == 0 { month_index = 11; year = year - 1; }
        else { month_index = month_index - 1; }
        selected_day = 0;
    }

    def next_month {
        if month_index == 11 { month_index = 0; year = year + 1; }
        else { month_index = month_index + 1; }
        selected_day = 0;
    }

    def jump_to_event(date_text: str) {
        parts = date_text.split("-");
        if len(parts) == 3 {
            year = int(parts[0]);
            month_index = int(parts[1]) - 1;
            selected_day = int(parts[2]) as int;
        }
    }

    async def save_event {
        if role != "Teacher" { message = "Only teachers may schedule events."; return; }
        if not title.strip() or not event_date.strip() { message = "Enter an event title and date."; return; }
        parts = event_date.split("-");
        if len(parts) != 3 { message = "Use a date in YYYY-MM-DD format."; return; }
        created = await create_calendar_event(title, event_date, details, "teacher-demo");
        if created {
            events = events + [created];
            jump_to_event(event_date);
            title = "";
            event_date = "";
            details = "";
            message = "Event added to the calendar.";
        } else { message = "Only an authorized teacher profile can add events."; }
    }

    month_names: list[str] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    month_name = month_names[month_index];
    first_weekday = new(Date, year, month_index, 1).getDay();
    days_in_month = new(Date, year, month_index + 1, 0).getDate();
    month_number = "0" + str(month_index + 1) if month_index + 1 < 10 else str(month_index + 1);
    first_weekday_int = int(first_weekday);
    days_in_month_int = int(days_in_month);
    calendar_days: list[int] = [];
    for cell_index in range(42) {
        day_number = int(cell_index - first_weekday_int + 1);
        if day_number >= 1 and day_number <= days_in_month_int { calendar_days = calendar_days + [day_number]; }
        else { calendar_days = calendar_days + [0]; }
    }

    return <div className="min-h-screen bg-rose-50"><div className="mx-auto flex min-h-screen max-w-[1440px]"><aside className="hidden w-64 shrink-0 flex-col border-r border-rose-200 bg-white px-5 py-6 md:flex"><Link to="/" className="mb-8 flex items-center gap-3"><span className="flex size-10 items-center justify-center rounded-xl bg-primary text-primary-foreground"><HugeiconsIcon icon={Home01Icon} strokeWidth={2} className="size-5" /></span><span><span className="block font-semibold">Schoolhouse</span><span className="block text-xs text-muted-foreground">Family portal</span></span></Link><nav className="flex flex-col gap-1"><Link to="/" className="rounded-lg px-3 py-2.5 text-sm text-muted-foreground hover:bg-muted">Overview</Link>{role == "Teacher" and <Link to="/students" className="rounded-lg px-3 py-2.5 text-sm text-muted-foreground hover:bg-muted">Students</Link>}<Link to="/progress" className="rounded-lg px-3 py-2.5 text-sm text-muted-foreground hover:bg-muted">Learning progress</Link><Link to="/homework" className="rounded-lg px-3 py-2.5 text-sm text-muted-foreground hover:bg-muted">Homework</Link><Link to="/calendar" className="rounded-lg bg-primary/10 px-3 py-2.5 text-sm font-medium text-primary">Calendar</Link><Link to="/notices" className="rounded-lg px-3 py-2.5 text-sm text-muted-foreground hover:bg-muted">Notices</Link><Link to="/messages" className="rounded-lg px-3 py-2.5 text-sm text-muted-foreground hover:bg-muted">Messages</Link><Link to="/profiles" className="rounded-lg px-3 py-2.5 text-sm text-muted-foreground hover:bg-muted">Profiles</Link><Link to="/materials" className="rounded-lg px-3 py-2.5 text-sm text-muted-foreground hover:bg-muted">Learning materials</Link><Link to="/event-media" className="rounded-lg px-3 py-2.5 text-sm text-muted-foreground hover:bg-muted">Event media</Link></nav></aside><main className="min-w-0 flex-1 px-4 py-6 sm:px-6 lg:px-9 lg:py-8"><header className="mb-6 flex flex-wrap items-center justify-between gap-4"><Link to="/" className="font-semibold md:hidden">Schoolhouse</Link><div className="flex items-center gap-2 text-xs text-muted-foreground"><span className="size-3 rounded-sm bg-sky-300" />School events<span className="ml-3 size-3 rounded-sm bg-fuchsia-300" />Birthdays</div></header><div className="mb-5 flex flex-wrap items-end justify-between gap-4"><div><p className="text-sm font-medium text-primary">Oakwood Primary · Shared calendar</p><h1 className="font-serif text-5xl font-normal uppercase tracking-tight text-slate-950 sm:text-6xl">{month_name}</h1><p className="mt-1 text-sm text-muted-foreground">{str(year)} · School dates and student birthdays</p></div><div className="flex items-center gap-2"><Button variant="outline" size="icon" onClick={previous_month} aria-label="Previous month"><HugeiconsIcon icon={ArrowLeft01Icon} strokeWidth={2} className="size-4" /></Button><Button variant="outline" onClick={lambda { year = 2026; month_index = 9; selected_day = 0; }}>Today</Button><Button variant="outline" size="icon" onClick={next_month} aria-label="Next month"><HugeiconsIcon icon={ArrowRight01Icon} strokeWidth={2} className="size-4" /></Button></div></div><p className="mb-3 text-sm text-muted-foreground">Browse all months with the arrows. Select an event below to jump to its date.</p><div className="overflow-hidden rounded-sm border border-slate-700 bg-white shadow-sm"><div className="grid grid-cols-7 border-b border-slate-700 bg-fuchsia-100/70">{for (weekday, short_day) in [("Sunday", "Sun"), ("Monday", "Mon"), ("Tuesday", "Tue"), ("Wednesday", "Wed"), ("Thursday", "Thu"), ("Friday", "Fri"), ("Saturday", "Sat")] {<div key={weekday} className="border-r border-slate-500 px-0.5 py-3 text-center text-[8px] font-semibold uppercase tracking-normal text-slate-700 sm:px-2 sm:text-[11px] sm:tracking-[0.16em]"><span className="sm:hidden">{short_day}</span><span className="hidden sm:inline">{weekday}</span></div>}}</div><div className="grid grid-cols-7">{for (cell_index, day_number) in enumerate(calendar_days) {if day_number > 0 {day_text = ("0" if day_number < 10 else "") + str(day_number); cell_date = str(year) + "-" + month_number + "-" + day_text; <div key={str(cell_index) + "-" + str(month_index) + "-" + str(year)} className={"min-h-20 border-b border-r border-slate-500 p-1.5 sm:min-h-28 sm:p-2 " + ("bg-fuchsia-50" if selected_day == day_number else "bg-white")}><button onClick={lambda { selected_day = day_number; }} className="text-xs font-medium text-slate-900">{day_number}</button>{month_index == 2 and day_number == 12 and <div className="mt-2 rounded-sm bg-fuchsia-100 px-1 py-1 text-[9px] font-medium leading-tight text-fuchsia-900 sm:text-[11px]">Maya birthday</div>}{for ev in events {if ev.event_date == cell_date {<button key={ev.title} onClick={lambda { selected_day = day_number; }} className="mt-2 block w-full rounded-sm bg-sky-100 px-1 py-1 text-left text-[9px] font-medium leading-tight text-sky-900 sm:text-[11px]">{ev.title}</button>}}}</div>} else {<div key={str(cell_index) + "-blank-" + str(month_index) + "-" + str(year)} className="min-h-20 border-b border-r border-slate-500 bg-white sm:min-h-28" />}}}</div></div><div className="mt-5 grid gap-4 lg:grid-cols-5"><Card className="border-sky-200 bg-white shadow-sm lg:col-span-3"><CardHeader><CardTitle>Events this year</CardTitle><CardDescription>Select an event to jump to its month and date.</CardDescription></CardHeader><CardContent className="flex flex-col gap-2">{for ev in events {<button key={jid(ev)} onClick={lambda { jump_to_event(ev.event_date); }} className="flex items-center gap-3 rounded-lg border p-3 text-left hover:bg-sky-50"><span className="size-3 shrink-0 rounded-sm bg-sky-300" /><span><span className="block text-sm font-medium">{ev.title}</span><span className="text-xs text-muted-foreground">{ev.event_date} · {ev.details}</span></span></button>}}</CardContent></Card><Card className="border-fuchsia-200 bg-white shadow-sm lg:col-span-2"><CardHeader><CardTitle>Birthdays</CardTitle><CardDescription>Birthday markers are pink</CardDescription></CardHeader><CardContent><button onClick={lambda { year = 2026; month_index = 2; selected_day = 12; }} className="flex w-full items-center gap-3 rounded-lg bg-fuchsia-100 p-3 text-left"><span className="size-3 shrink-0 rounded-sm bg-fuchsia-300" /><span><span className="block text-sm font-medium text-fuchsia-950">Maya Patel</span><span className="text-xs text-fuchsia-800">12 March · Grade 3</span></span></button></CardContent></Card></div>{loading and <p className="mt-4 text-sm text-muted-foreground">Loading calendar events…</p>}{message and <p className="mt-4 text-sm text-muted-foreground">{message}</p>}{role == "Teacher" and <Card className="mt-5 border-sky-200 bg-white shadow-sm"><CardHeader><CardTitle>Schedule an event</CardTitle><CardDescription>Only teachers may add calendar events.</CardDescription></CardHeader><CardContent><div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4"><label className="flex flex-col gap-1 text-sm">Event title<input value={title} onChange={lambda (e: ChangeEvent) { title = e.target.value; }} placeholder="Class assembly" className="h-10 rounded-lg border bg-background px-3" /></label><label className="flex flex-col gap-1 text-sm">Date<input type="text" value={event_date} onChange={lambda (e: ChangeEvent) { event_date = e.target.value; }} placeholder="2026-10-19" className="h-10 rounded-lg border bg-background px-3" /></label><label className="flex flex-col gap-1 text-sm lg:col-span-2">Details<input value={details} onChange={lambda (e: ChangeEvent) { details = e.target.value; }} placeholder="A short note for families" className="h-10 rounded-lg border bg-background px-3" /></label></div><div className="mt-3 flex flex-wrap items-center gap-3"><Button onClick={save_event}><HugeiconsIcon icon={Add01Icon} strokeWidth={2} className="size-4" />Add school event</Button></div></CardContent></Card>}</main></div></div>;
}
