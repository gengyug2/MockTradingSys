%% %*****Matching Engine*****
% This engine is supposed to update live order lists
% and tell whether there is a transaction

ind=1;
traded_q=0;

if (buy_sell_robot_j==1)
    while price_robot_j>=live_sell_orders_list(ind,3)&&(live_sell_orders_list(ind,4)>0)&&(quantity_robot_j>0)
        traded_q=min(quantity_robot_j,live_sell_orders_list(ind,4));
        quantity_robot_j=quantity_robot_j-traded_q;
        live_sell_orders_list(ind,4)=live_sell_orders_list(ind,4)-traded_q;
        transac_ind=sum(transaction_price_volume_stor_mat(:,1)~=0);
        transaction_price_volume_stor_mat(transac_ind+1,:)=[t,1,live_sell_orders_list(ind,3),traded_q,live_sell_orders_list(ind,6),live_sell_orders_list(ind,1),robot_j_acct_id];
        if live_sell_orders_list(ind,4)==0
            live_sell_orders_list(ind,:)=zeros(1,7);
        end;
        ind=ind+1;
    end
    if quantity_robot_j>0   
        live_buy_orders_list(end,:)=[robot_j_acct_id,buy_sell_robot_j,price_robot_j,quantity_robot_j,t,order_id,alive_indicator_robot_j];
        live_buy_orders_list=sortrows(live_buy_orders_list,[-7 -3 6]);
    end   
    if traded_q>0
        live_sell_orders_list=sortrows(live_sell_orders_list,[-7 3 6]);
    end
else
    while (quantity_robot_j>0)&&price_robot_j<=live_buy_orders_list(ind,3)&&(live_buy_orders_list(ind,4)>0)
        traded_q=min(quantity_robot_j,live_buy_orders_list(ind,4));
        quantity_robot_j=quantity_robot_j-traded_q;
        live_buy_orders_list(ind,4)=live_buy_orders_list(ind,4)-traded_q;
        transac_ind=sum(transaction_price_volume_stor_mat(:,1)~=0);
        transaction_price_volume_stor_mat(transac_ind+1,:)=[t,-1,price_robot_j,traded_q,live_buy_orders_list(ind,6),live_buy_orders_list(ind,1),robot_j_acct_id];
        if live_buy_orders_list(ind,4)==0
            live_buy_orders_list(ind,:)=zeros(1,7);
        end
        ind=ind+1;
    end;
    if quantity_robot_j>0
        live_sell_orders_list(end,:)=[robot_j_acct_id,buy_sell_robot_j,price_robot_j,quantity_robot_j,t,order_id,alive_indicator_robot_j];
        live_sell_orders_list=sortrows(live_sell_orders_list,[-7 3 6]);
    end
    if traded_q>0
        live_buy_orders_list=sortrows(live_buy_orders_list,[-7 -3 6]);
    end
end;