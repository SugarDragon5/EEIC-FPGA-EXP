module tsp (
    clk,rst,xs,ys,path,performance
);
    input clk,rst;
    //頂点座標
    output wire [7:0] xs[63:0],ys[63:0];
    //経路
    output reg [5:0] path[63:0];
    output wire [31:0] performance;
    //グラフ情報
    wire is_completed_graphgen;
    graph graph(
        .clk(clk),.rst(rst),
        .xs(xs),.ys(ys),
        .complete(is_completed_graphgen)
    );
    //状況変数
    reg [31:0] phase;
    reg [31:0] total_difference;
    reg [31:0] locked[63:0];
    //カウンタ変数
    integer i;
    genvar j;
    //非隣接点交換ソルバ変数
    parameter SOL1_PARALLEL_NUM = 5;
    reg [31:0] state_sol1[SOL1_PARALLEL_NUM];
    reg [5:0] v1_sol1[SOL1_PARALLEL_NUM],v2_sol1[SOL1_PARALLEL_NUM];
    reg [31:0] rand_val_sol1[SOL1_PARALLEL_NUM];
    reg [31:0] rand_seed_sol1[SOL1_PARALLEL_NUM];
    ////(x1,y1)->v1(x2,y2)->(x3,y3) (x4,y4)->v2(x5,y5)->(x6,y6)
    reg [7:0] x1_sol1[SOL1_PARALLEL_NUM],y1_sol1[SOL1_PARALLEL_NUM];
    reg [7:0] x2_sol1[SOL1_PARALLEL_NUM],y2_sol1[SOL1_PARALLEL_NUM];
    reg [7:0] x3_sol1[SOL1_PARALLEL_NUM],y3_sol1[SOL1_PARALLEL_NUM];
    reg [7:0] x4_sol1[SOL1_PARALLEL_NUM],y4_sol1[SOL1_PARALLEL_NUM];
    reg [7:0] x5_sol1[SOL1_PARALLEL_NUM],y5_sol1[SOL1_PARALLEL_NUM];
    reg [7:0] x6_sol1[SOL1_PARALLEL_NUM],y6_sol1[SOL1_PARALLEL_NUM];
    reg reset_swap_sol1[SOL1_PARALLEL_NUM];
    reg should_swap_sol1[SOL1_PARALLEL_NUM], complete_check_swap_sol1[SOL1_PARALLEL_NUM];
    reg [31:0] swap_difference_sol1[SOL1_PARALLEL_NUM];
    generate
        for(j=0;j<SOL1_PARALLEL_NUM;j++)begin: gen1
            xorshift xs(.rst(rst),.clk(clk),.seed(rand_seed_sol1[j]),.res(rand_val_sol1[j]));
            checkswap cs(
                .clk(clk),.rst(reset_swap_sol1[j]),
                .x1(x1_sol1[j]),.y1(y1_sol1[j]),
                .x2(x2_sol1[j]),.y2(y2_sol1[j]),
                .x3(x3_sol1[j]),.y3(y3_sol1[j]),
                .x4(x4_sol1[j]),.y4(y4_sol1[j]),
                .x5(x5_sol1[j]),.y5(y5_sol1[j]),
                .x6(x6_sol1[j]),.y6(y6_sol1[j]),
                .res(should_swap_sol1[j]),
                .complete(complete_check_swap_sol1[j]),
                .difference(swap_difference_sol1[j])
            );
        end
    endgenerate
    //隣接頂点交換ソルバ
    parameter SOL2_PARALLEL_NUM = 2;
    reg [31:0] state_sol2[SOL2_PARALLEL_NUM];
    reg [5:0] v_sol2[SOL2_PARALLEL_NUM];
    reg [31:0] rand_val_sol2[SOL2_PARALLEL_NUM];
    reg [31:0] rand_seed_sol2[SOL2_PARALLEL_NUM];
    ////v(x1,y1)->(x2,y2)->(x3,y3)->(x4,y4)
    reg [7:0] x1_sol2[SOL2_PARALLEL_NUM],y1_sol2[SOL2_PARALLEL_NUM];
    reg [7:0] x2_sol2[SOL2_PARALLEL_NUM],y2_sol2[SOL2_PARALLEL_NUM];
    reg [7:0] x3_sol2[SOL2_PARALLEL_NUM],y3_sol2[SOL2_PARALLEL_NUM];
    reg [7:0] x4_sol2[SOL2_PARALLEL_NUM],y4_sol2[SOL2_PARALLEL_NUM];
    reg reset_swap_sol2[SOL2_PARALLEL_NUM];
    reg should_swap_sol2[SOL2_PARALLEL_NUM], complete_check_swap_sol2[SOL2_PARALLEL_NUM];
    reg [31:0] swap_difference_sol2[SOL2_PARALLEL_NUM];
    generate
        for(j=0;j<SOL2_PARALLEL_NUM;j++)begin: gen2
            xorshift xs(.rst(rst),.clk(clk),.seed(rand_seed_sol2[j]),.res(rand_val_sol2[j]));
            checkswap_adjacent csa(
                .clk(clk),.rst(reset_swap_sol2[j]),
                .x1(x1_sol2[j]),.y1(y1_sol2[j]),
                .x2(x2_sol2[j]),.y2(y2_sol2[j]),
                .x3(x3_sol2[j]),.y3(y3_sol2[j]),
                .x4(x4_sol2[j]),.y4(y4_sol2[j]),
                .res(should_swap_sol2[j]),
                .complete(complete_check_swap_sol2[j]),
                .difference(swap_difference_sol2[j])
            );
        end
    endgenerate
    assign performance=total_difference;
    always @(posedge clk ) begin
        if(rst)begin
            //リセット入力
            phase<=0;
            total_difference<=0;
            rand_seed_sol1[0]<=3141592;
            rand_seed_sol1[1]<=65358979;
            rand_seed_sol1[2]<=32384626;
            rand_seed_sol1[3]<=43383279;
            rand_seed_sol1[4]<=50288419;
            rand_seed_sol2[0]<=71693993;
            rand_seed_sol2[1]<=75105820;
        end else if(phase==0)begin
            //グラフの生成とパスの初期化
            if(is_completed_graphgen)begin
                phase<=1;
            end

            for(i=0;i<SOL1_PARALLEL_NUM;i++)begin
                state_sol1[i]<=0;
            end
            for(i=0;i<SOL2_PARALLEL_NUM;i++)begin
                state_sol2[i]<=0;
            end
            for(i=0;i<64;i++)begin
                path[i]<=i;
                locked[i]<=-1;
            end
        end else if(phase==1)begin
            //並列処理(非隣接ソルバ)
            for(i=0;i<SOL1_PARALLEL_NUM;i++)begin
                if(state_sol1[i]==0)begin
                    //v1を取得
                    //v1の条件は、v1-1, v1, v1+1がロックされていないこと
                    if(locked[rand_val_sol1[i][5:0]-1]==-1 && locked[rand_val_sol1[i][5:0]]==-1 && locked[rand_val_sol1[i][5:0]+1]==-1)begin
                        v1_sol1[i]<=rand_val_sol1[i][5:0];
                        state_sol1[i]<=1;
                    end
                end else if(state_sol1[i]==1)begin
                    //v2を取得
                    //v2の条件は、v2-1, v2, v2+1がロックされていないことと、v1とv2が隣接していないこと
                    if(locked[rand_val_sol1[i][5:0]-1]==-1 && locked[rand_val_sol1[i][5:0]]==-1 && locked[rand_val_sol1[i][5:0]+1]==-1)begin
                        if(v1_sol1[i]!=rand_val_sol1[i][5:0] && v1_sol1[i]+1!=rand_val_sol1[i][5:0] && v1_sol1[i]!=rand_val_sol1[i][5:0]+1)begin
                            v2_sol1[i]<=rand_val_sol1[i][5:0];
                            state_sol1[i]<=2;
                        end
                    end
                end else if(state_sol1[i]==2)begin
                    //ロックして入力
                    locked[v1_sol1[i]-1]<=i*2;
                    locked[v1_sol1[i]]<=i*2;
                    locked[v1_sol1[i]+1]<=i*2;
                    locked[v2_sol1[i]-1]<=i*2;
                    locked[v2_sol1[i]]<=i*2;
                    locked[v2_sol1[i]+1]<=i*2;
                    x1_sol1[i]<=xs[path[v1_sol1[i]-1]]; y1_sol1[i]<=ys[path[v1_sol1[i]-1]];
                    x2_sol1[i]<=xs[path[v1_sol1[i]]];   y2_sol1[i]<=ys[path[v1_sol1[i]]];
                    x3_sol1[i]<=xs[path[v1_sol1[i]+1]]; y3_sol1[i]<=ys[path[v1_sol1[i]+1]];
                    x4_sol1[i]<=xs[path[v2_sol1[i]-1]]; y4_sol1[i]<=ys[path[v2_sol1[i]-1]];
                    x5_sol1[i]<=xs[path[v2_sol1[i]]];   y5_sol1[i]<=ys[path[v2_sol1[i]]];
                    x6_sol1[i]<=xs[path[v2_sol1[i]+1]]; y6_sol1[i]<=ys[path[v2_sol1[i]+1]];
                    state_sol1[i]<=3;
                    reset_swap_sol1[i]<=1;
                end else if(state_sol1[i]==3)begin
                    //ロックに成功しているか確認。
                    if(locked[v1_sol1[i]-1]!=i*2 || locked[v1_sol1[i]]!=i*2 || locked[v1_sol1[i]+1]!=i*2 || locked[v2_sol1[i]-1]!=i*2 || locked[v2_sol1[i]]!=i*2 || locked[v2_sol1[i]+1]!=i*2)begin
                        //ロックに失敗しているので、ロックを解除して、v1,v2を再取得
                        state_sol1[i]<=0;
                        if(locked[v1_sol1[i]-1]==i*2)locked[v1_sol1[i]-1]<=-1;
                        if(locked[v1_sol1[i]]==i*2)locked[v1_sol1[i]]<=-1;
                        if(locked[v1_sol1[i]+1]==i*2)locked[v1_sol1[i]+1]<=-1;
                        if(locked[v2_sol1[i]-1]==i*2)locked[v2_sol1[i]-1]<=-1;
                        if(locked[v2_sol1[i]]==i*2)locked[v2_sol1[i]]<=-1;
                        if(locked[v2_sol1[i]+1]==i*2)locked[v2_sol1[i]+1]<=-1;
                    end else begin
                        state_sol1[i]<=4;
                        reset_swap_sol1[i]<=0;
                    end
                end else if(state_sol1[i]==4)begin
                    //結果が得られ、交換したほうが良ければ交換。ロックを解除
                    if(complete_check_swap_sol1[i])begin
                        if(should_swap_sol1[i])begin
                            path[v1_sol1[i]]<=path[v2_sol1[i]];
                            path[v2_sol1[i]]<=path[v1_sol1[i]];
                            total_difference<=total_difference+swap_difference_sol1[i];
                        end
                        state_sol1[i]<=0;
                        reset_swap_sol1[i]<=0;
                        locked[v1_sol1[i]-1]<=-1;
                        locked[v1_sol1[i]]<=-1;
                        locked[v1_sol1[i]+1]<=-1;
                        locked[v2_sol1[i]-1]<=-1;
                        locked[v2_sol1[i]]<=-1;
                        locked[v2_sol1[i]+1]<=-1;
                    end
                end
            end
            //並列処理(隣接ソルバ)
            for(i=0;i<SOL2_PARALLEL_NUM;i++)begin
                if(state_sol2[i]==0)begin
                    //vを取得
                    //vの条件は、v, v+1, v+2, v+3がロックされていないこと
                    if(locked[rand_val_sol2[i][5:0]]==-1 && locked[rand_val_sol2[i][5:0]+1]==-1 && locked[rand_val_sol2[i][5:0]+2]==-1 && locked[rand_val_sol2[i][5:0]+3]==-1)begin
                        v_sol2[i]<=rand_val_sol2[i][5:0];
                        state_sol2[i]<=1;
                    end
                end else if(state_sol2[i]==1)begin
                    //ロックして入力
                    locked[v_sol2[i]]<=i*2+1;
                    locked[v_sol2[i]+1]<=i*2+1;
                    locked[v_sol2[i]+2]<=i*2+1;
                    locked[v_sol2[i]+3]<=i*2+1;
                    x1_sol2[i]<=xs[path[v_sol2[i]]];    y1_sol2[i]<=ys[path[v_sol2[i]]];
                    x2_sol2[i]<=xs[path[v_sol2[i]+1]];  y2_sol2[i]<=ys[path[v_sol2[i]+1]];
                    x3_sol2[i]<=xs[path[v_sol2[i]+2]];  y3_sol2[i]<=ys[path[v_sol2[i]+2]];
                    x4_sol2[i]<=xs[path[v_sol2[i]+3]];  y4_sol2[i]<=ys[path[v_sol2[i]+3]];
                    state_sol2[i]<=2;
                    reset_swap_sol2[i]<=1;
                end else if(state_sol2[i]==2)begin
                    //ロックに成功しているか確認。
                    if(locked[v_sol2[i]]!=i*2+1 || locked[v_sol2[i]+1]!=i*2+1 || locked[v_sol2[i]+2]!=i*2+1 || locked[v_sol2[i]+3]!=i*2+1)begin
                        //ロックに失敗しているので、ロックを解除して、v1,v2を再取得
                        state_sol2[i]<=0;
                        if(locked[v_sol2[i]]==i*2+1)locked[v_sol2[i]]<=-1;
                        if(locked[v_sol2[i]+1]==i*2+1)locked[v_sol2[i]+1]<=-1;
                        if(locked[v_sol2[i]+2]==i*2+1)locked[v_sol2[i]+2]<=-1;
                        if(locked[v_sol2[i]+3]==i*2+1)locked[v_sol2[i]+3]<=-1;
                    end else begin
                        state_sol2[i]<=3;
                        reset_swap_sol2[i]<=0;
                    end
                end else if(state_sol2[i]==3)begin
                    //結果が得られ、交換したほうが良ければ交換。ロックを解除
                    if(complete_check_swap_sol2[i])begin
                        if(should_swap_sol2[i])begin
                            path[v_sol2[i]+1]<=path[v_sol2[i]+2];
                            path[v_sol2[i]+2]<=path[v_sol2[i]+1];
                            total_difference<=total_difference+swap_difference_sol2[i];
                        end
                        state_sol2[i]<=0;
                        reset_swap_sol2[i]<=0;
                        locked[v_sol2[i]]<=-1;
                        locked[v_sol2[i]+1]<=-1;
                        locked[v_sol2[i]+2]<=-1;
                        locked[v_sol2[i]+3]<=-1;
                    end
                end
            end
        end
    end
    
endmodule