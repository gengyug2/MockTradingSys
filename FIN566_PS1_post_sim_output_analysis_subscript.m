transaction_price_volume_stor_mat=sortrows(transaction_price_volume_stor_mat(transaction_price_volume_stor_mat(:,2)~=0,:),-1);

% total number of the trades
total_number_of_the_trades=transac_ind+1;

% bid_ask_spread plot
bid_ask_spread=abs(bid_ask_stor_mat(:,2)-bid_ask_stor_mat(:,1));
subplot(3,3,1)
plot(bid_ask_spread)
ylim([0,max_price+1])
xlim([0,t_max])

% bid_ask_mean
bid_ask_mean=mean(bid_ask_stor_mat,2);
bid_ask_mean=[(burn_in_period+1:t-1)',bid_ask_mean(burn_in_period+1:end,:)];

% LOB plot
subplot(3,3,2)
bar(LOB(:,1),LOB(:,2:3),'stacked')

% bid_ask plot
subplot(3,3,3)
plot(bid_ask_stor_mat)
xlim([0,t_max])

% bid_ask partial plot
subplot(3,3,4)
plot(burn_in_period+1:t_max,bid_ask_stor_mat(burn_in_period+1:end,:))
xlim([burn_in_period,t_max])

% bid_ask depth plot
subplot(3,3,5)
bar(bid_ask_depth_stor_mat,'hist')
xlim([0,t_max+1])

% 
trader_z_id=robot_j_acct_id;
trader_z_cash_inventory_and_value=zeros(t_max,3);
target_panel=zeros(0,7);
trader_z_volumn=0;

cash=0;
inv=0;
dirty_price=0;

for i=1:t_max
    if size(target_panel,1)~=size(transaction_price_volume_stor_mat(transaction_price_volume_stor_mat(:,1)<=i,:),1)
        idx = size(target_panel, 1);
        iter=size(transaction_price_volume_stor_mat(transaction_price_volume_stor_mat(:,1)<=i,:),1)-size(target_panel,1);
        target_panel=transaction_price_volume_stor_mat(transaction_price_volume_stor_mat(:,1)<=i,:);
        dirty_price=target_panel(1,3);
        for j=1:iter
            if target_panel(j + idx,6)==trader_z_id
                cash=cash+target_panel(j,2)*target_panel(j,3)*target_panel(j,4);
                inv=inv-target_panel(j,2)*target_panel(j,4);
                trader_z_volumn=trader_z_volumn+target_panel(j,4);
            end
            if target_panel(j + idx,7)==trader_z_id
                cash=cash-target_panel(j,2)*target_panel(j,3)*target_panel(j,4);
                inv=inv+target_panel(j,2)*target_panel(j,4);
                trader_z_volumn=trader_z_volumn+target_panel(j,4);
            end
        end
    end
    trader_z_cash_inventory_and_value(i,:)=[cash,inv,inv*dirty_price];
end

% cash position, profit, and inventory market value
subplot(3,3,6)
plot([trader_z_cash_inventory_and_value(:,1),trader_z_cash_inventory_and_value(:,1)+trader_z_cash_inventory_and_value(:,3),trader_z_cash_inventory_and_value(:,3)]);
xlim([0,t_max])

% inventory shares
subplot(3,3,7)
plot(trader_z_cash_inventory_and_value(:,2));
xlim([0,t_max])

robot_z_total_trading_profit=trader_z_cash_inventory_and_value(end,1)+trader_z_cash_inventory_and_value(end,3);
robot_z_total_trading_volume=trader_z_volumn;
robot_z_final_inventory_position=trader_z_cash_inventory_and_value(end,3);
robot_z_final_cash_position=trader_z_cash_inventory_and_value(end,1);

