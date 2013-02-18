function [error_rate] = compute_error(user_list,recommend_list)
    
    %user_list:user_id|movie_id|rating|timestamp
    %recommend_list:user_id|recommend_movie_id|score
   
    threshold = 4;
    
    %error(1,1) test_user likes a movie, but we didn't recommend this movie
    %error(1,2) test_user doesn't like this movie, but we did recommend this
    %movie
    error = zeros(1,2);
    for user_x = 1:size(user_list,1)
        %a = find(user_list(:,1) == user_x);
        user_id = user_list(user_x,1);
        a = find(recommend_list(:,1) == user_id);
        if ~isempty(a)
            recommend_film = zeros(size(a,1),1);
            s = a(1,1)+size(a,1)-1;
            recommend_film(:,1) = recommend_list(a(1,1):s,2);
            b = find(recommend_film(:,1) == user_list(user_x,2), 1);
            if ~isempty(b)
                if user_list(user_x,3) < threshold
                    error(1,2) = error(1,2) + 1;
                end
            else
                if user_list(user_x,3) >= threshold
                    error(1,1) = error(1,1) + 1;
                end
            end
        end
    end
    error_rate = zeros(1,3);
    error_rate(1,1) = error(1,1)/(size(recommend_list,1)+error(1,1));
    error_rate(1,2) = error(1,2)/size(recommend_list,1);
    error_rate(1,3) = (error(1,1) + error(1,2))/(size(recommend_list,1)+error(1,1));
end