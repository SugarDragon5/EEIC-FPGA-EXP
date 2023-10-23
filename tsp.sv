module tsp (
    clk,rst,xs,ys,path,performance
);
    input clk,rst;
    //頂点座標
    output wire [31:0] xs[63:0],ys[63:0];
    //経路
    output reg [31:0] path[63:0];
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
    //ソルバ変数
    parameter PARALLEL_NUM = 5;
    reg [31:0] state[PARALLEL_NUM];
    reg [31:0] v1[PARALLEL_NUM],v2[PARALLEL_NUM];
    reg [31:0] rand_val[PARALLEL_NUM];
    reg [31:0] rand_seed[PARALLEL_NUM];
    ////(x1,y1)->v1(x2,y2)->(x3,y3) (x4,y4)->v2(x5,y5)->(x6,y6)
    reg [31:0] x1[PARALLEL_NUM],y1[PARALLEL_NUM];
    reg [31:0] x2[PARALLEL_NUM],y2[PARALLEL_NUM];
    reg [31:0] x3[PARALLEL_NUM],y3[PARALLEL_NUM];
    reg [31:0] x4[PARALLEL_NUM],y4[PARALLEL_NUM];
    reg [31:0] x5[PARALLEL_NUM],y5[PARALLEL_NUM];
    reg [31:0] x6[PARALLEL_NUM],y6[PARALLEL_NUM];
    reg reset_swap[PARALLEL_NUM];
    reg should_swap[PARALLEL_NUM], complete_check_swap[PARALLEL_NUM];
    reg [31:0] swap_difference[PARALLEL_NUM];
    reg [31:0] total_difference;
    reg [31:0] locked[63:0];
    integer i;
    genvar j;
    generate
        for(j=0;j<PARALLEL_NUM;j++)begin
            xorshift xs(.rst(rst),.clk(clk),.seed(rand_seed[j]),.res(rand_val[j]));
            checkswap cs(
                .clk(clk),.rst(reset_swap[j]),
                .x1(x1[j]),.y1(y1[j]),
                .x2(x2[j]),.y2(y2[j]),
                .x3(x3[j]),.y3(y3[j]),
                .x4(x4[j]),.y4(y4[j]),
                .x5(x5[j]),.y5(y5[j]),
                .x6(x6[j]),.y6(y6[j]),
                .res(should_swap[j]),
                .complete(complete_check_swap[j]),
                .difference(swap_difference[j])
            );
        end
    endgenerate
    assign performance=total_difference;
    initial begin
        rand_seed[0]<=3141592;
        rand_seed[1]<=65358979;
        rand_seed[2]<=32384626;
        rand_seed[3]<=43383279;
        rand_seed[4]<=50288419;
    end
    always @(posedge clk ) begin
        if(rst)begin
            //リセット入力
            phase<=0;
            total_difference<=0;
        end else if(phase==0)begin
            //グラフの生成とパスの初期化
            if(is_completed_graphgen)begin
                phase<=1;
            end

            for(i=0;i<PARALLEL_NUM;i++)begin
                state[i]<=0;
            end
            for(i=0;i<64;i++)begin
                path[i]<=i;
                locked[i]<=-1;
            end
        end else if(phase==1)begin
            //並列処理
            for(i=0;i<PARALLEL_NUM;i++)begin
                if(state[i]==0)begin
                    //v1を取得
                    //v1の条件は、v1-1, v1, v1+1がロックされていないこと
                    if(locked[rand_val[i]%62]==-1 && locked[rand_val[i]%62+1]==-1 && locked[rand_val[i]%62+2]==-1)begin
                        v1[i]<=rand_val[i]%62+1;   //todo
                        state[i]<=1;
                    end
                end else if(state[i]==1)begin
                    //v2を取得
                    //v2の条件は、v2-1, v2, v2+1がロックされていないことと、v1とv2が隣接していないこと
                    if(locked[rand_val[i]%62]==-1 && locked[rand_val[i]%62+1]==-1 && locked[rand_val[i]%62+2]==-1)begin
                        if(v1[i]!=rand_val[i]%62+1 && v1[i]+1!=rand_val[i]%62+1 && v1[i]!=rand_val[i]%62+2)begin
                            v2[i]<=rand_val[i]%62+1;   //todo
                            state[i]<=2;
                        end
                    end
                end else if(state[i]==2)begin
                    //ロックして入力
                    locked[v1[i]-1]<=i;
                    locked[v1[i]]<=i;
                    locked[v1[i]+1]<=i;
                    locked[v2[i]-1]<=i;
                    locked[v2[i]]<=i;
                    locked[v2[i]+1]<=i;
                    x1[i]<=xs[path[v1[i]-1]]; y1[i]<=ys[path[v1[i]-1]];
                    x2[i]<=xs[path[v1[i]]]; y2[i]<=ys[path[v1[i]]];
                    x3[i]<=xs[path[v1[i]+1]]; y3[i]<=ys[path[v1[i]+1]];
                    x4[i]<=xs[path[v2[i]-1]]; y4[i]<=ys[path[v2[i]-1]];
                    x5[i]<=xs[path[v2[i]]]; y5[i]<=ys[path[v2[i]]];
                    x6[i]<=xs[path[v2[i]+1]]; y6[i]<=ys[path[v2[i]+1]];
                    state[i]<=3;
                    reset_swap[i]<=1;
                end else if(state[i]==3)begin
                    //ロックに成功しているか確認。
                    if(locked[v1[i]-1]!=i || locked[v1[i]]!=i || locked[v1[i]+1]!=i || locked[v2[i]-1]!=i || locked[v2[i]]!=i || locked[v2[i]+1]!=i)begin
                        //ロックに失敗しているので、ロックを解除して、v1,v2を再取得
                        state[i]<=0;
                        if(locked[v1[i]-1]==i)locked[v1[i]-1]<=-1;
                        if(locked[v1[i]]==i)locked[v1[i]]<=-1;
                        if(locked[v1[i]+1]==i)locked[v1[i]+1]<=-1;
                        if(locked[v2[i]-1]==i)locked[v2[i]-1]<=-1;
                        if(locked[v2[i]]==i)locked[v2[i]]<=-1;
                        if(locked[v2[i]+1]==i)locked[v2[i]+1]<=-1;
                    end else begin
                        state[i]<=4;
                        reset_swap[i]<=0;
                    end
                end else if(state[i]==4)begin
                    //結果が得られ、交換したほうが良ければ交換。ロックを解除
                    if(complete_check_swap[i])begin
                        if(should_swap[i])begin
                            path[v1[i]]<=path[v2[i]];
                            path[v2[i]]<=path[v1[i]];
                            total_difference<=total_difference+swap_difference[i];
                        end
                        state[i]<=0;
                        reset_swap[i]<=0;
                        locked[v1[i]-1]<=-1;
                        locked[v1[i]]<=-1;
                        locked[v1[i]+1]<=-1;
                        locked[v2[i]-1]<=-1;
                        locked[v2[i]]<=-1;
                        locked[v2[i]+1]<=-1;
                    end
                end
            end
        end
    end
    
endmodule