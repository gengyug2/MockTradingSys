live_buy=live_buy_orders_list(live_buy_orders_list(:,7)==1,:);
[prices,~,rowIdx]=unique(live_buy(:,3),'rows');
subtotal=accumarray(rowIdx,live_buy(:,4),[],@sum);
buy_lob_depth=sortrows([prices,subtotal],-1);

live_sell=live_sell_orders_list(live_sell_orders_list(:,7)==1,:);
[prices,~,rowIdx]=unique(live_sell(:,3),'rows');
subtotal=accumarray(rowIdx,live_sell(:,4),[],@sum);
sell_lob_depth=[prices,subtotal];

if isempty(sell_lob_depth)
    sell_lob_depth=zeros(1,2);
end

if isempty(buy_lob_depth)
    buy_lob_depth=zeros(1,2);
end

% target 3&4
bid_ask_depth_stor_mat(t,:)=[buy_lob_depth(1,2),sell_lob_depth(1,2)];
bid_ask_stor_mat(t,:)=[buy_lob_depth(1,1),sell_lob_depth(1,1)];

% target 567&8
best_bid=buy_lob_depth(1,1);
best_ask=sell_lob_depth(1,1);
depth_at_best_bid=buy_lob_depth(1,2);
depth_at_best_ask=sell_lob_depth(1,2);

% LOB
LOB=[buy_lob_depth,zeros(size(buy_lob_depth,1),1);sell_lob_depth(:,1),zeros(size(sell_lob_depth,1),1),sell_lob_depth(:,2)];
