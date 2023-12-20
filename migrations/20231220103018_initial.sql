CREATE TABLE workspace (
    id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL
);

CREATE TABLE users (
    id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid()
);

CREATE TABLE box (
    id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by_id UUID NOT NULL,
    type TEXT NOT NULL,
    workspace_id UUID NOT NULL REFERENCES workspace(id)
);

CREATE TABLE warehouse (
    id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by_id UUID NOT NULL,
    box_id UUID NOT NULL REFERENCES box(id),
    workspace_id UUID NOT NULL REFERENCES workspace(id)
);

CREATE TABLE container (
    id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by_id UUID NOT NULL,
    workspace_id UUID NOT NULL REFERENCES workspace(id),
    box_id UUID NOT NULL REFERENCES box(id)
);

CREATE TABLE data_set (
    id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by_id UUID NOT NULL,
    collection_id UUID NOT NULL,
    workspace_id UUID NOT NULL REFERENCES workspace(id)
);

CREATE TABLE platform (
    id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by_id UUID NOT NULL,
    data_set_id UUID REFERENCES data_set(id),
    workspace_id UUID NOT NULL REFERENCES workspace(id)
);

CREATE TABLE data_set_metadata (
    data_set_id UUID NOT NULL REFERENCES data_set(id),
    owner_id UUID REFERENCES users(id),
    workspace_id UUID NOT NULL REFERENCES workspace(id),

    CONSTRAINT data_set_metadata_pkey PRIMARY KEY (data_set_id)
);

CREATE TABLE container_data_set_bridge (
    container_id UUID NOT NULL REFERENCES container(id),
    data_set_id UUID NOT NULL REFERENCES data_set(id),
    workspace_id UUID NOT NULL REFERENCES workspace(id),

    CONSTRAINT container_data_set_bridge_pkey PRIMARY KEY (container_id,data_set_id)
);

ALTER TABLE warehouse ADD COLUMN connector_version TEXT NOT NULL;

