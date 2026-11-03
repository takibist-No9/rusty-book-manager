use std::net::{Ipv4Addr, SocketAddr};

use adapter::database::connect_database_with;
use anyhow::{Error, Result};
use api::route::health::build_health_check_routers;
use axum::Router;
use registry::AppRegistry;
use shared::config::AppConfig;
use tokio::net::TcpListener;

#[tokio::main]
async fn main() -> Result<()> {
    boostrap().await
}

// 1) 後々ログの初期化など他の関数をmain関数内で挟むため、いまのうちにサーバ起動分だけ分離しておく
async fn boostrap() -> Result<()> {
    // 2) `AppConfig`を生成させる
    let app_config = AppConfig::new()?;
    // 3) データベースの接続を行う。コネクションプールを取り出しておく
    let pool = connect_database_with(&app_config.database);

    // 4) `AppRegistry`を生成する
    let registry = AppRegistry::new(pool);

    // 5) `build_health_check_routers`関数を呼び出す。`AppRegistry`を`Router`に登録
    let app = Router::new()
        .merge(build_health_check_routers())
        .with_state(registry);

    // 6) サーバーを起動する
    let addr = SocketAddr::new(Ipv4Addr::LOCALHOST.into(), 8080);
    let listener = TcpListener::bind(&addr).await?;

    println!("Listening on {}", addr);

    axum::serve(listener, app).await.map_err(Error::from)
}
