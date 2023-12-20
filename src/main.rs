use sqlx::{postgres::PgPoolOptions, types::Uuid};

#[derive(Debug)]
struct QueryResult {
    pub data_set_id: Uuid,
    pub reference_id: Option<Uuid>,
    pub workspace_name: String,
    pub warehouse_type: String,
}

#[tokio::main]
async fn main() -> Result<(), sqlx::Error> {
    dotenvy::dotenv().unwrap();

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&std::env::var("DATABASE_URL").unwrap())
        .await?;

    let a = sqlx::query_as!(
        QueryResult,
        r#"
        SELECT
            da.data_set_id,
            CASE
                WHEN container.container_id IS NOT NULL THEN container.container_id
                WHEN platform.id IS NOT NULL THEN platform.id
                ELSE NULL
            END AS reference_id,
            w.title as workspace_name,
            b.type as warehouse_type
        FROM data_set_metadata AS da
        INNER JOIN data_set AS ds
            ON da.data_set_id = ds.id
        INNER JOIN workspace AS w
            ON da.workspace_id = w.id
        INNER JOIN warehouse AS wm
            ON da.workspace_id = wm.workspace_id
        INNER JOIN box AS b
            ON wm.box_id = b.id
        LEFT JOIN container_data_set_bridge AS container
            ON container.data_set_id = ds.id
        LEFT JOIN platform
            ON platform.data_set_id = ds.id
        "#
    )
    .fetch_all(&pool)
    .await?;
    dbg!(a);

    Ok(())
}
