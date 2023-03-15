DROP PROCEDURE IF EXISTS sp_delete_user;
DELIMITER $$
CREATE PROCEDURE sp_delete_user (IN del_user INT)
BEGIN
	START TRANSACTION;
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
	COMMIT;
	DELETE uc, p, mes, m, l, fr
    FROM users u JOIN users_communities uc ON u.id = uc.user_id
		JOIN profiles p ON u.id = p.user_id
			JOIN messages mes ON u.id = mes.from_user_id OR u.id = mes.to_user_id
				JOIN likes l ON u.id = l.user_id
					JOIN media m ON u.id = m.user_id
						JOIN friend_requests fr ON u.id = fr.initiator_user_id OR u.id = fr.target_user_id
		WHERE u.id = del_user;
    DELETE FROM users u 
 		WHERE u.id = del_user;
END;
$$
DELIMITER ;

CALL sp_delete_user(5);