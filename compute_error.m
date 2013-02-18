function [error_rate] = compute_error(user_list,recommend_list)
    
    %user_list:user_id|movie_id|rating|timestamp
    %recommend_list:user_id|recommend_movie_id|score
   
    threshold = 4;
    error = 0;
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
                    error = error + 1;
                end
            else
                if user_list(user_x,3) >= threshold
                    error = error + 1;
                end
            end
        end
    end
    error_rate = error/size(recommend_list,1);
end