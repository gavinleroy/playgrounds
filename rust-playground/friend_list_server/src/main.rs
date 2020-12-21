use std::fs;
use httparse;
use std::net::{TcpListener, TcpStream};
use std::io::prelude::*;

// requests
// static BASE_REQ: &str = b"GET /";
// static FRIEND_REQ

#[derive(Debug)]
enum FriendRequest {
    Friend(String),
    Befriend(String, Vec<String>),
    Introduce(String, Vec<String>),
}

impl FriendRequest {
    // TODO implement
}

fn main() {
    let listener = TcpListener::bind("127.0.0.1:8080").unwrap();

    for stream in listener.incoming() {
        let stream = stream.unwrap();

        handle_connection(stream);
    }
}

fn handle_connection(mut stream: TcpStream) -> Result<(), String> {
    let mut buffer = [0; 2048];

    stream.read(&mut buffer).unwrap();

    // deconstruct into new FriendRequest
    let friend_req = parse_request(&mut buffer)?;

    serve_friends(&stream, &friend_req)?;

    // let response = format!("HTTP/1.1 200 OK\r\n\r\n{}", contents);

    // stream.write(response.as_bytes()).unwrap();
    // stream.flush().unwrap();

    Ok(())
}

// -----------------------------------//
// ------- serving functions ---------//
// -----------------------------------//

fn serve_friends(mut stream: &TcpStream, req: &FriendRequest) -> Result<(), String> {

    let contents = fs::read_to_string("good.html").unwrap();
    let response = format!("HTTP/1.1 200 OK\r\n\r\n{}", contents);

    stream.write(response.as_bytes()).unwrap();
    stream.flush().unwrap();

    Ok(())
}

// -----------------------------------//
// ------------ helpers --------------//
// -----------------------------------//

fn parse_request(buffer: &[u8]) -> Result<FriendRequest, String> {
    let mut headers = [httparse::EMPTY_HEADER; 16];
    let mut req = httparse::Request::new(&mut headers);
    req.parse(&buffer).unwrap();

    let path = match req.path {
        Some(ref path) => path,
        _ => return Err("Invalid uri".to_owned()),
    };

    let q_pos = path.find("?");
    let a_pos = path.find("&");
    let u_pos = path.find("user=");
    let f_pos = path.find("friends=");

    let (req_type, user) = match (q_pos, u_pos) {
        (Some(i), Some(j)) => (&path[..i], 
                               &path[j+5usize..a_pos.unwrap_or(path.len())]) ,
        _ => return Err("Invalid uri".to_owned()),
    };

    match (req_type,  f_pos) {
        ("/friends", _) => {
            Ok(FriendRequest::Friend(user.to_owned()))
        }
        ("/befriend", Some(i)) => {
            Ok(FriendRequest::Befriend(user.to_owned(), 
                                       parse_friends(&path[i+8usize..])?))
        }
        ("/introduce", Some(i)) => {
            Ok(FriendRequest::Introduce(user.to_owned(), 
                                        parse_friends(&path[i+8usize..])?))
        }
        _ => Err("Invalid uri".to_owned()),
    }
}

fn parse_friends(s: &str) -> Result<Vec<String>, String> {
    let v = s.split(",")
        .map(|s| s.to_owned())
        .collect::<Vec<String>>();
    if v.len() > 0 {
        Ok(v)
    } else {
        Err("No friends".to_owned())
    }
}

// // #define DEBUG
// #define LOCK_ALL
// // #define LOCK_SEPARATE

// static void * doit(void * fd);
// static dictionary_t *read_requesthdrs(rio_t *rp);
// static void read_postquery(rio_t *rp, dictionary_t *headers, dictionary_t *d);
// static void clienterror(int fd, char *cause, char *errnum, 
//                         char *shortmsg, char *longmsg);
// static void * dictionary_get_decode(dictionary_t * dic, char * str);
// static void send_on_return_friends(int fd, char * user);

// static char * get_friends_internal(char * user, char * buf);
// static char * get_friends_external(char * user, char * host, char * port, char * buf);

// static char * get_header(char * user);
// static dictionary_t * get_user_dic(char * user);
// static void remove_user_dic(dictionary_t * dic, char * user);
// static void befriend(char * user, char * friends);
// static void free_friend_dic(void * ptr);

// static void serve_friends(int fd, dictionary_t *query);
// static void serve_add(int fd, dictionary_t *query);
// static void serve_remove(int fd, dictionary_t *query);
// static void serve_intro(int fd, dictionary_t *query);

// #ifdef DEBUG
// static void print_stringdictionary(dictionary_t *d);
// #endif

// static dictionary_t * friend_dic = NULL;
// static pthread_mutex_t friend_lock;
// static char my_port[6];

// int main(int argc, char **argv) {
//   int listenfd, * connfd;
//   char hostname[MAXLINE], port[MAXLINE];
//   socklen_t clientlen;
//   struct sockaddr_storage clientaddr;
//   pthread_t th;

//   /* Check command line args */
//   if (argc != 2) {
//     fprintf(stderr, "usage: %s <port>\n", argv[0]);
//     exit(1);
//   }

//   /* Initialize the overall friend list */
//   friend_dic = make_dictionary(COMPARE_CASE_SENS, free_friend_dic);
//   pthread_mutex_init(&friend_lock, NULL);

//   strcpy(my_port, argv[1]);
//   listenfd = Open_listenfd(argv[1]);

//   /* Don't kill the server if there's an error, because
//      we want to survive errors due to a client. But we
//      do want to report errors. */
//   exit_on_error(0);

//   /* Also, don't stop on broken connections: */
//   Signal(SIGPIPE, SIG_IGN);

//   while (1) {
//     connfd = malloc(sizeof(int));
//     clientlen = sizeof(clientaddr);
//     *connfd = Accept(listenfd, (SA *)&clientaddr, &clientlen);
//     if (*connfd >= 0) {
//       Getnameinfo((SA *) &clientaddr, clientlen, hostname, MAXLINE, 
//                   port, MAXLINE, 0);
//       printf("Accepted connection from (%s, %s)\n", hostname, port);
//       Pthread_create(&th, NULL, doit, connfd);
//       Pthread_detach(th);
//     }
//   }
// }

// /*
//  * doit - handle one HTTP request/response transaction
//  */
// static void * doit(void  * fdptr) {
//   int fd = *((int *)fdptr);
//   char buf[MAXLINE], *method, *uri, *version;
//   rio_t rio;
//   dictionary_t *headers, *query;

//   free(fdptr);

//   /* Read request line and headers */
//   Rio_readinitb(&rio, fd);
//   if (Rio_readlineb(&rio, buf, MAXLINE) <= 0)
//     return NULL;

//   if (!parse_request_line(buf, &method, &uri, &version)) {
//     clienterror(fd, method, "400", "Bad Request",
//                 "Friendlist did not recognize the request");
//   } else {
//     if (strcasecmp(version, "HTTP/1.0")
//         && strcasecmp(version, "HTTP/1.1")) {
//       clienterror(fd, version, "501", "Not Implemented",
//                   "Friendlist does not implement that version");
//     } else if (strcasecmp(method, "GET")
//                && strcasecmp(method, "POST")) {
//       clienterror(fd, method, "501", "Not Implemented",
//                   "Friendlist does not implement that method");
//     } else {
//       headers = read_requesthdrs(&rio);

//       /* Parse all query arguments into a dictionary */
//       query = make_dictionary(COMPARE_CASE_SENS, free);

//       parse_uriquery(uri, query);
//       if (!strcasecmp(method, "POST"))
//         read_postquery(&rio, headers, query);

// #ifdef DEBUG
//   printf("METHOD %s\n", method);
//   printf("URI %s\n", uri);
//   printf("VERSION %s\n", version);
// #endif

//       /* Choose the query type */
//       if(starts_with("/friends", uri))
//         serve_friends(fd, query);
//       else if(starts_with("/befriend", uri))
//         serve_add(fd, query); 
//       else if(starts_with("/unfriend", uri))
//         serve_remove(fd, query); 
//       else if(starts_with("/introduce", uri))
//         serve_intro(fd, query);
//       else 
//         clienterror(fd, "Query path invalid", "500", "short msg", "long msg");

//       /* Clean up */
//       free_dictionary(query);
//       free_dictionary(headers);
//     }

//     /* Clean up status line */
//     free(method);
//     free(uri);
//     free(version);
//   }

//   Close(fd);
//   return NULL;
// }

// /*
//  * read_requesthdrs - read HTTP request headers
//  */
// static dictionary_t *read_requesthdrs(rio_t *rp) {
//   char buf[MAXLINE];
//   dictionary_t *d = make_dictionary(COMPARE_CASE_INSENS, free);

//   Rio_readlineb(rp, buf, MAXLINE);
//   printf("%s", buf);
//   while(strcmp(buf, "\r\n")) {
//     Rio_readlineb(rp, buf, MAXLINE);
//     printf("%s", buf);
//     parse_header_line(buf, d);
//   }
  
//   return d;
// }

// static void read_postquery(rio_t *rp, dictionary_t *headers, dictionary_t *dest) {
//   char *len_str, *type, *buffer;
//   int len;
  
//   len_str = dictionary_get(headers, "Content-Length");
//   len = (len_str ? atoi(len_str) : 0);

//   type = dictionary_get(headers, "Content-Type");
  
//   buffer = malloc(len+1);
//   Rio_readnb(rp, buffer, len);
//   buffer[len] = 0;

//   if (!strcasecmp(type, "application/x-www-form-urlencoded")) {
//     parse_query(buffer, dest);
//   }

//   free(buffer);
// }

// static char *ok_header(size_t len, const char *content_type) {
//   char *len_str, *header;
  
//   header = append_strings("HTTP/1.0 200 OK\r\n",
//                           "Server: Friendlist Web Server\r\n",
//                           "Connection: close\r\n",
//                           "Content-length: ", len_str = to_string(len), "\r\n",
//                           "Content-type: ", content_type, "\r\n\r\n",
//                           NULL);
//   free(len_str);

//   return header;
// }

// /* create the post request header for requesting info */
// static char * get_header(char * user) {
//   char *header, * encuser;
//   encuser = query_encode(user);
//   header = append_strings("GET /friends?user=", encuser, " HTTP/1.0\r\n\r\n", NULL);
//   free(encuser);
//   return header;
// }

// /*
//  * serve_friends - return the list of friends
//  */
// static void serve_friends(int fd, dictionary_t *query) {
//   char * user = dictionary_get_decode(query, "user");

// #ifdef LOCK_ALL
//   pthread_mutex_lock(&friend_lock);
// #endif

//   send_on_return_friends(fd, user);

// #ifdef LOCK_ALL
//   pthread_mutex_unlock(&friend_lock);
// #endif

//   free(user);
// }

// /*
//  * serve_add - return the list of friends
//  */
// static void serve_add(int fd, dictionary_t *query) {
//   char * user = dictionary_get_decode(query, "user");
//   char * friends = dictionary_get_decode(query, "friends"); 

// #ifdef LOCK_ALL
//   pthread_mutex_lock(&friend_lock);
// #endif

//   befriend(user, friends);
//   send_on_return_friends(fd, user);

// #ifdef LOCK_ALL
//   pthread_mutex_unlock(&friend_lock);
// #endif

//   free(user);
//   free(friends);
// }

// /*
//  * serve_remove - return the list of friends
//  */
// static void serve_remove(int fd, dictionary_t *query) {
//   char * user = dictionary_get_decode(query, "user");
//   char * friends = dictionary_get_decode(query, "friends");
//   char ** friend_list = split_string(friends, '\n');

// #ifdef LOCK_ALL
//   pthread_mutex_lock(&friend_lock);
// #endif

//   dictionary_t * user_dic = get_user_dic(user);

//   int i;
//   dictionary_t * befriend_dic;
//   for(i = 0; friend_list[i]; i++) {
//     befriend_dic = get_user_dic(friend_list[i]);

// #ifdef LOCK_SEPARATE
//     pthread_mutex_lock(&friend_lock);
// #endif

//     dictionary_remove(befriend_dic, user);
//     dictionary_remove(user_dic, friend_list[i]);

// #ifdef LOCK_SEPARATE
//     pthread_mutex_unlock(&friend_lock);
// #endif

//     remove_user_dic(befriend_dic, friend_list[i]);
//     free(friend_list[i]);
//   }

//   remove_user_dic(user_dic, user);

//   send_on_return_friends(fd, user);

// #ifdef LOCK_ALL
//   pthread_mutex_unlock(&friend_lock);
// #endif

//   free(user);
//   free(friends);
//   free(friend_list);
// }

// /* serve the introduce request */
// static void serve_intro(int fd, dictionary_t *query) {
// #ifdef DEBUG
//   printf("USER %s\n", (char *)dictionary_get_decode(query, "user"));
//   printf("FRIEND %s\n", (char *)dictionary_get_decode(query, "friend"));
//   printf("HOST %s\n", (char *)dictionary_get_decode(query, "host"));
//   printf("PORT %s\n", (char *)dictionary_get_decode(query, "port"));
// #endif

//   char * host = dictionary_get_decode(query, "host");
//   char * port = dictionary_get_decode(query, "port");
//   char * user = dictionary_get_decode(query, "user");
//   char * friend = dictionary_get_decode(query, "friend");
//   char * buf = malloc(1000 * MAXLINE * sizeof(char));

// #ifdef LOCK_ALL
//   pthread_mutex_lock(&friend_lock);
// #endif

//   char * new_friends;

//   if((!strcmp(host, "localhost") || !strcmp(host, "127.0.0.1")) && !strcmp(port, my_port)) {
//     new_friends = get_friends_internal(friend, buf);
//   } else {
// #ifdef LOCK_ALL
//   pthread_mutex_unlock(&friend_lock);
// #endif
//     new_friends = get_friends_external(friend, host, port, buf); 
// #ifdef LOCK_ALL
//   pthread_mutex_lock(&friend_lock);
// #endif
//   }

//   befriend(user, friend);

//   if(new_friends) {
//     befriend(user, new_friends);
//     send_on_return_friends(fd, user);
//   } else 
//     clienterror(fd, "Problem contacting friend server", "500", "short msg", "long msg");

// #ifdef LOCK_ALL
//   pthread_mutex_unlock(&friend_lock);
// #endif

//   free(buf);
//   free(host);
//   free(port);
//   free(user);
//   free(friend);
// }

// static char * get_friends_internal(char * user, char * buf) {
//   char * ret_friends;
//   dictionary_t * user_dic = get_user_dic(user);

//   const char ** all_users = dictionary_keys(user_dic);

//   ret_friends = join_strings(all_users, '\n');

//   strcpy(buf, ret_friends);

//   free(ret_friends);
//   free(all_users);

//   return buf;
// }

// static char * get_friends_external(char * user, char * host, char * port, char * buf) {
//   int newfd =  open_clientfd(host, port);
//   char * header = get_header(user);

//   if(newfd > 0) {
//     Rio_writen(newfd, header, strlen(header));
//     Shutdown(newfd, SHUT_WR);
//   }

//   if(newfd > 0 && Rio_readn(newfd, buf, MAXLINE)) {
//     char * status_p, temp, * beg = buf;

//     while(beg[1] != '\n') 
//       beg++;
//     temp = beg[2];
//     beg[2] = '\0';

//     if(parse_status_line(buf, NULL, &status_p, NULL)) {
//       if(starts_with("200", status_p)) {
//         beg[2] = temp;
//         while(!(beg[0] == '\r' && beg[1] == '\n' && 
//                 beg[2] == '\r' && beg[3] == '\n')) 
//           beg++;
//         beg += 4;

//         Close(newfd);
//         free(header);
//         return beg;
//       }     
//     }
//     free(status_p);
//   } 

//   Close(newfd);
//   free(header);
//   return NULL;
// }

// static void befriend(char * user, char * friends) {
//   char ** friend_list = split_string(friends, '\n');

//   dictionary_t * befriend_dic, * user_dic = get_user_dic(user);

//   int i;
//   for(i = 0; friend_list[i]; i++) {
//     if(strcmp(user, friend_list[i])) {
//       befriend_dic = get_user_dic(friend_list[i]);

// #ifdef LOCK_SEPARATE
//       pthread_mutex_lock(&friend_lock);
// #endif

//       dictionary_set(befriend_dic, user, NULL);
//       dictionary_set(user_dic, friend_list[i], NULL);

// #ifdef LOCK_SEPARATE
//       pthread_mutex_unlock(&friend_lock);
// #endif
//     }
//     free(friend_list[i]);
//   }
//   free(friend_list);
// }

// static void remove_user_dic(dictionary_t * dic, char * user) {
// #ifdef LOCK_SEPARATE
//   pthread_mutex_lock(&friend_lock);
// #endif
//   if(!dictionary_count(dic))
//     dictionary_remove(friend_dic, user);
// #ifdef LOCK_SEPARATE
//   pthread_mutex_unlock(&friend_lock);
// #endif
// }

// static dictionary_t * get_user_dic(char * user) {
// #ifdef LOCK_SEPARATE
//   pthread_mutex_lock(&friend_lock);
// #endif

//   dictionary_t * user_dic = dictionary_get(friend_dic, user);
//   if( !user_dic ) {
//     user_dic = make_dictionary(COMPARE_CASE_SENS, NULL);
//     dictionary_set(friend_dic, user, user_dic);
//   }

// #ifdef LOCK_SEPARATE
//   pthread_mutex_unlock(&friend_lock);
// #endif
//   return user_dic;
// }

// static void send_on_return_friends(int fd, char * user) {
//   size_t len;
//   char *body, *header;

//   dictionary_t * user_dic = get_user_dic(user);

// #ifdef LOCK_SEPARATE
//   pthread_mutex_lock(&friend_lock);
// #endif
  
//   const char ** friend_list = dictionary_keys(user_dic);

//   body = join_strings(friend_list, '\n');

// #ifdef LOCK_SEPARATE
//   pthread_mutex_unlock(&friend_lock);
// #endif

//   len = strlen(body);

//   /* Send response headers to client */
//   header = ok_header(len, "text/html; charset=utf-8");
//   Rio_writen(fd, header, strlen(header));

//   /* Send response body to client */
//   Rio_writen(fd, body, len);

//   free(header);
//   free(friend_list);
//   free(body);
// }

// static void * dictionary_get_decode(dictionary_t * dic, char * str) {
//   char * newstr = dictionary_get(dic, str);
//   newstr = query_decode(newstr);
//   return newstr;
// }

// static void clienterror(int fd, char *cause, char *errnum, 
// 		 char *shortmsg, char *longmsg) {
//   size_t len;
//   char *header, *body, *len_str;

//   body = append_strings("<html><title>Friendlist Error</title>",
//                         "<body bgcolor=""ffffff"">\r\n",
//                         errnum, " ", shortmsg,
//                         "<p>", longmsg, ": ", cause,
//                         "<hr><em>Friendlist Server</em>\r\n",
//                         NULL);
//   len = strlen(body);

//   /* Print the HTTP response */
//   header = append_strings("HTTP/1.0 ", errnum, " ", shortmsg, "\r\n",
//                           "Content-type: text/html; charset=utf-8\r\n",
//                           "Content-length: ", len_str = to_string(len), "\r\n\r\n",
//                           NULL);
//   free(len_str);
  
//   Rio_writen(fd, header, strlen(header));
//   Rio_writen(fd, body, len);

//   free(header);
//   free(body);
// }
