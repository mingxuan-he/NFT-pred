-- Parameters:
-- end_date (default 2023-09-30)
-- nft_contract_address
    -- BAYC: 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d

WITH 
collection AS
(
    SELECT 
        *
    FROM nft_ethereum.collection_stats
    WHERE nft_contract_address = {{nft_contract_address}}
),

trades AS
(
    SELECT
        *
    FROM nft.trades
    WHERE nft_contract_address = {{nft_contract_address}}
)

SELECT
    project,
    version,
    t.block_date,
    t.block_month,
    t.block_time,
    t.token_id,
    collection,
    amount_usd,
    token_standard,
    trade_type,
    number_of_items,
    trade_category,
    evt_type,
    amount_original,
    currency_symbol,
    tx_hash,
    volume_eth,
    price_p5_eth,
    price_min_eth,
    price_max_eth
FROM 
    trades t
LEFT JOIN 
    collection c
ON 
    t.block_date = c.block_date
--WHERE token_id = CAST(7019 AS UINT256)
WHERE 
    t.block_date <= CAST('{{end_date}}' AS DATE)
ORDER BY 
    token_id ASC,
    block_time ASC
--LIMIT 1000