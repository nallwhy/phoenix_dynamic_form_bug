defmodule DynamicFormWeb.Live do
  use DynamicFormWeb, :live_view

  defmodule Person do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field(:name, :string)

      embeds_many :contracts, Contract, primary_key: false, on_replace: :delete do
        field(:file_name, :string)
      end
    end

    def changeset(%__MODULE__{} = struct, attrs) do
      struct
      |> cast(attrs, [:name])
      |> cast_embed(
        :contracts,
        with: &changeset_contract/2,
        sort_param: :contracts_sort,
        drop_param: :contracts_drop
      )
    end

    def changeset_contract(%__MODULE__.Contract{} = struct, attrs) do
      struct
      |> cast(attrs, [:file_name])
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        :person_form,
        Person.changeset(%Person{}, %{contracts: [%{}]}) |> to_form(as: :person)
      )

    {:ok, socket}
  end

  # render
  @impl true
  def render(assigns) do
    ~H"""
    <.simple_form for={@person_form} phx-change="validate">
      <.input label="name" field={@person_form[:name]} />
      <.inputs_for :let={fc} field={@person_form[:contracts]}>
        <.field_adder_hidden for={fc} name="person[contracts_sort][]" />
        <.input label="file name" field={fc[:file_name]} />
        <.label>
          <input type="checkbox" name="person[contracts_drop][]" value={fc.index} /> remove
        </.label>
      </.inputs_for>

      <input type="hidden" name="person[contracts_drop][]" />

      <label class="block cursor-pointer">
        <input type="checkbox" name="person[contracts_sort][]" /> add more1
      </label>

      <.field_adder name="person[contracts_sort][]" label="add more2" />
    </.simple_form>
    """
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    person_form =
      %Person{}
      |> Person.changeset(person_params)
      |> Map.put(:action, :validate)
      |> to_form()

    socket =
      socket
      |> assign(:person_form, person_form)

    {:noreply, socket}
  end

  attr(:for, :any, required: true)
  attr(:name, :string, required: true)

  def field_adder_hidden(assigns) do
    ~H"""
    <input type="hidden" name={@name} value={@for.index} />
    """
  end

  attr(:name, :string, required: true)
  attr(:label, :string, default: nil)

  def field_adder(assigns) do
    ~H"""
    <label class="block cursor-pointer">
      <input type="checkbox" name={@name} />
      <%= @label %>
    </label>
    """
  end
end
