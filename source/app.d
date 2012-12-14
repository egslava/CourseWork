module source.app;
import vibe.d;
//import sass;
import std.process;
import source.sha256;
import std.stdio;

/**
 * Main page
 * If user is not logged in yet, page'll suggest to user
 * log in (/sign_in) or create account (/new_user)
 * if user is already logged in, it'll redirect him to /profile page
 *
 * On the profile page, there are one links:
 * 1. Create note (/new_note)
 * 2. Sign out link (/sign_out)
 * 3. List of notes 
 * 4. Link "remove note" opposite note (/remove_note command)
*/

MongoDB db;
MongoCollection userNotes;

bool userExists(string userName){
	return userNotes.count(["user": userName]) != 0;
}

bool auth(string userName, string passwordHash){
	return userNotes.count(["user": userName, "password": passwordHash]) > 0;
}

bool userRegister(string userName, string password){
	string hashedPassword = hex256(password);
	userNotes.insert( {user: userName, password: hex256(hashedPassword)});
}

// get("/")
void index(HttpServerRequest req, HttpServerResponse res){
	auto pageTitle = "Жесть, это просто магия шаблонов! :)";

	auto notes = userNotes.find();
	res.render!("index.dt", pageTitle, notes);
}

static this()
{ 
	writeln(hashToHex("Blah"));
	db = connectMongoDB("127.0.0.1");
	userNotes = db["test.usernotes"];
	system ("compass compile ./public/styles/compass");
	
	auto router = new UrlRouter;
	router.get("/", &index)
			.get("*", serveStaticFiles("./public/"));

	auto settings = new HttpServerSettings;
	settings.port = 8080;

	listenHttp(settings, router);
    //logInfo("Edit source/app.d to start your project.");
}
