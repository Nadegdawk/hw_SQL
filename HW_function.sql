DROP FUNCTION IF EXISTS delete_user;
	ALTER TABLE friend_requests DROP FOREIGN KEY friend_requests_ibfk_1;
	ALTER TABLE friend_requests ADD CONSTRAINT friend_requests_ibfk_1 FOREIGN KEY (initiator_user_id) REFERENCES users(id) ON DELETE CASCADE;
    ALTER TABLE friend_requests DROP FOREIGN KEY friend_requests_ibfk_2;
	ALTER TABLE friend_requests ADD CONSTRAINT friend_requests_ibfk_2 FOREIGN KEY (target_user_id) REFERENCES users(id) ON DELETE CASCADE;
 	ALTER TABLE likes DROP FOREIGN KEY likes_ibfk_1;
 	ALTER TABLE likes ADD CONSTRAINT likes_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
    ALTER TABLE likes DROP FOREIGN KEY likes_ibfk_2;
	ALTER TABLE likes ADD CONSTRAINT likes_ibfk_2 FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE CASCADE;
    ALTER TABLE profiles DROP FOREIGN KEY profiles_ibfk_1;
	ALTER TABLE profiles ADD CONSTRAINT profiles_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
    ALTER TABLE profiles DROP FOREIGN KEY profiles_ibfk_2;
	ALTER TABLE profiles ADD CONSTRAINT profiles_ibfk_2 FOREIGN KEY (photo_id) REFERENCES media(id) ON DELETE CASCADE;
    ALTER TABLE media DROP FOREIGN KEY media_ibfk_1;
	ALTER TABLE media ADD CONSTRAINT media_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
  	ALTER TABLE messages DROP FOREIGN KEY messages_ibfk_1;
 	ALTER TABLE messages ADD CONSTRAINT messages_ibfk_1 FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE CASCADE;
    ALTER TABLE messages DROP FOREIGN KEY messages_ibfk_2;
	ALTER TABLE messages ADD CONSTRAINT messages_ibfk_2 FOREIGN KEY (to_user_id) REFERENCES users(id) ON DELETE CASCADE;
    ALTER TABLE users_communities DROP FOREIGN KEY users_communities_ibfk_1;
	ALTER TABLE users_communities ADD CONSTRAINT users_communities_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

DELIMITER $$
CREATE FUNCTION delete_user (del_user INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE id_del INT;
    SET id_del = del_user;
	DELETE FROM friend_requests fr WHERE fr.target_user_id = id_del;
	DELETE FROM friend_requests fr WHERE fr.initiator_user_id = id_del;
    DELETE FROM likes l WHERE l.user_id = id_del;
	DELETE FROM media m WHERE m.user_id = id_del;
	DELETE FROM profiles p WHERE p.user_id = id_del;    
	DELETE FROM messages mes WHERE mes.from_user_id = id_del;
    DELETE FROM messages mes WHERE mes.to_user_id = id_del;
    DELETE FROM likes l WHERE l.user_id = id_del;
	DELETE FROM users u WHERE u.id = id_del;
    RETURN id_del;
END;
$$
DELIMITER ;

SELECT delete_user(11);