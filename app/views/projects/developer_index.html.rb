<p id="notice"><%= notice %></p>


<h1>Developer Projects</h1>
<% if @projects.length > 0%>
  <table>
    <thead>
      <tr>
        <th>Project Title</th>
        <th>Description</th>
        <th>Start date</th>
        <th colspan="3">Actions</th>
      </tr>
    </thead>

    <tbody>

      <% @projects.each do |project| %>
        <tr>
          <td><%= project.title %></td>
          <td><%= project.description %></td>
          <td><%= project.start_date %></td>
          <td>
            <% if current_user.user_type == 0 %>
            <%= link_to 'Edit Project', edit_project_path(project), {:class => "btn btn-primary btn-xs"} %>
            <%end%>
          </td>
          <td>
            <% if current_user.user_type == 0 %>
            <%= link_to 'Manage Members', "projects/"+project.id.to_s+"/manage-members", {:class => "btn btn-info btn-xs"} %>
            <%end%>
          </td>
          <td class="btn btn-danger btn-xs">
            <% if current_user.user_type == 0 %>
            <%= link_to 'Delete', project, method: :delete, data: { confirm: 'Are you sure?' }  %>
            <%end%>
          </td>
        </tr>
      <% end %>
    </tbody>
  </table>
<% else %>
  <p>No Projects Found</p>
<% end%>
<br>
<% if current_user.user_type == 0 %>
  <%= link_to 'Create New Project', new_project_path  , {:class => "btn btn-success text-bold"  }%>
<% end%>
